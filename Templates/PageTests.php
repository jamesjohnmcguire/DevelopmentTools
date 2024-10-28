<?php // phpcs:disable PSR1.Files.SideEffects.FoundWithSymbols

/**
 * End to End Page Tests.
 *
 * @package Template
 * @author  author <email>
 * @license Proprietary
 */

declare(strict_types=1);

namespace Template\Tests;

$root = dirname(__DIR__, 1);

require_once $root . '/SourceCode/vendor/autoload.php';

use DigitalZenWorks\ApiTest\PageTester;
use PHPUnit\Framework\Attributes\Group;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\TestCase;

/**
 * PageTests class.
 *
 * Contains all the automated API tests.
 */
final class PageTests extends TestCase
{
	private const LOCAL = 'http://localhost/';
	/**
	 * Page Tester object.
	 *
	 * @var PageTester
	 */
	private PageTester $pageTester;

	/**
	 * Server.
	 *
	 * @var string
	 */
	private string $server = 'local';

	/**
	 * Set up before class method.
	 *
	 * @return void
	 */
	public static function setUpBeforeClass() : void
	{
	}

	/**
	 * Set up method.
	 *
	 * @return void
	 */
	protected function setUp() : void
	{
		parent::setUp();

		$this->pageTester =
			new PageTester(self::LOCAL, 'text/html', 'text/html');
	}

	/**
	 * Tear down method.
	 *
	 * @return void
	 */
	protected function tearDown(): void
	{
		if ($this->server === 'remote')
		{
			sleep(1);
		}
	}

	#[Group('local')]
	#[Test]
	public function LocalHomePage()
	{
		$endPoint = self::LOCAL;

		$this->TestSitePage($endPoint);
	}

	/**
	 * Test page method.
	 *
	 * @return void
	 */
	private function TestSitePage(string $endPoint)
	{
		$response = $this->pageTester->testPage('GET', $endPoint, null);

		$this->assertNotNull($response);
		$this->assertNotEmpty($response);
		$this->assertStringContainsString('<!DOCTYPE html>', $response);
	}
}
