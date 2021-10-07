﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Процедура ПриПолученииНастроек(НастройкиПланаОбмена) Экспорт
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для БСП

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
// 
// Параметры:
//	Настройки - Структура - Сеодержит настройки по умолчанию
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "";
	Настройки.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "";
	Настройки.ЗаголовокПомощникаСозданияОбмена = НСтр("ru='Настройка синхронизации с 1С:Документооборотом КОРП, ред. 2.0'");
	Настройки.ЗаголовокУзлаПланаОбмена = НСтр("ru='Синхронизация с 1С:Документооборотом КОРП, ред. 2.0'");
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат "Настройки_обмена_ДОКОРП_БПКОРП";
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = 'Документооборот КОРП, редакция 2.0'");
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
// Например:
//	Возврат "ПланОбмена._ДемоРаспределеннаяИнформационнаяБаза.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
	Возврат Результат;
	
КонецФункции

// Возвращает версию подсистемы обмена данными
// Для вновь создаваемых планов обмена функция должна
// возвращать значение Перечисления.ВерсииПодсистемыОбменаДанными.Версия30
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ВерсииПодсистемыОбменаДанными
//
Функция ВерсияОбменаДанными() Экспорт
	
	Возврат Перечисления.ВерсииПодсистемыОбменаДанными.Версия30;
	
КонецФункции

Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "";
	
КонецФункции

// Функция возвращает имя обработки выгрузки данных
//
Функция ИмяОбработкиВыгрузки() Экспорт
	
	Возврат "ОбработчикиВыгрузкиВДокументооборотКОРП20";
	
КонецФункции // ИмяОбработкиВыгрузки()

// Функция возвращает имя обработки загрузки данных
//
Функция ИмяОбработкиЗагрузки() Экспорт
	
	Возврат "ОбработчикиЗагрузкиИзДокументооборотаКОРП20";
	
КонецФункции // ИмяОбработкиЗагрузки()

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные между конфигурациями ""Бухгалтерия предприятия КОРП"", ред. 3, и ""1С:Документооборот КОРП"", ред. 2.0.
	|Синхронизация данных выполняется в двустороннем режиме на уровне нормативно-справочной информации, договоров и заявок на оплату.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	Возврат "ПланОбмена.ОбменБухгалтерияПредприятияДокументооборот20.Форма.ПодробнаяИнформация";
	
КонецФункции

Функция ИмяКонфигурацииИсточника() Экспорт
	
	Возврат ОбщегоНазначенияБП.ИмяКонфигурацииИсточника();
	
КонецФункции

// Процедура предназначена для получения дополнительных данных, используемых при настройке обмена в базе-корреспонденте.
//
//  Параметры:
// ДополнительныеДанные – Структура. Дополнительные данные, которые будут использованы
// в базе-корреспонденте при настройке обмена.
// В качестве значений структуры применимы только значения, поддерживающие XDTO-сериализацию.
//
Процедура ПолучитьДополнительныеДанныеДляКорреспондента(ДополнительныеДанные) Экспорт
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Константы и проверка параметров учета

Функция ПояснениеДляНастройкиПараметровУчета() Экспорт

	Возврат "";

КонецФункции

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	Отбор = Неопределено;
	Отказ = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции для работы обмена через внешнее соединение

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация_Ключ", Новый Массив);
	СтруктураНастроек.Вставить("ОграничиватьВыгрузкуОрганизациями", Ложь);
	СтруктураНастроек.Вставить("Организации", СтруктураТабличнойЧастиОрганизации);
	
	СтруктураТабличнойЧастиДоговоры = Новый Структура;
	СтруктураТабличнойЧастиДоговоры.Вставить("ВидДокумента", Новый Массив);
	СтруктураТабличнойЧастиДоговоры.Вставить("ВидДокумента_Ключ", Новый Массив);
	СтруктураНастроек.Вставить("ВыгружатьДоговоры", Ложь);
	СтруктураНастроек.Вставить("Договоры", СтруктураТабличнойЧастиДоговоры);
	
	СтруктураТабличнойЧастиЗаявкиНаОплату = Новый Структура;
	СтруктураТабличнойЧастиЗаявкиНаОплату.Вставить("ВидДокумента", Новый Массив);
	СтруктураТабличнойЧастиЗаявкиНаОплату.Вставить("ВидДокумента_Ключ", Новый Массив);
	СтруктураНастроек.Вставить("ВыгружатьЗаявкиНаОплату", Ложь);
	СтруктураНастроек.Вставить("ЗаявкиНаОплату", СтруктураТабличнойЧастиЗаявкиНаОплату);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ГруппаДоступаКорреспондентов", "");
	СтруктураНастроек.Вставить("ГруппаДоступаКорреспондентов_Ключ", "");
	
	Возврат СтруктураНастроек;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
//  Параметры:
// ВерсияКорреспондента (только чтение) – Строка – версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать – Булево – признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая настройка дополнения выгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Cтрока            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Cтрока            - Заголовок для отрисовки на форме команды открытия формы настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно  использовать специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки, предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле "Ссылка.Организация"
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	Параметры.ВариантВсеДокументы.Использование      = Ложь;
	Параметры.ВариантБезДополнения.Использование     = Ложь;
	Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
	Параметры.ВариантДополнительно.Использование     = Ложь;
		
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку"
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут быть использованы специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", будет использовано поле "Ссылка.Организация"
//
// Возвращаемое значение: 
//     Строка - описание отбора
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Возврат "";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли