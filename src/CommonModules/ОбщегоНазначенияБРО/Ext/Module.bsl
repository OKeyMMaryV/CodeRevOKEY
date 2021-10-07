﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность БРО".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Для задания обработчиков параметров сеанса следует использовать шаблон:
// Обработчики.Вставить("<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>", "Обработчик");
//
// Примечание. Символ '*'используется в конце имени параметра сеанса и обозначает,
//             что один обработчик будет вызван для инициализации всех параметров сеанса
//             с именем, начинающимся на слово НачалоИмениПараметраСеанса
//
Процедура ОбработчикиИнициализацииПараметровСеанса(Обработчики) Экспорт
	
	// Электронный документооборот с контролирующими органами
	Обработчики.Вставить("ТекущиеУчетныеЗаписиНалогоплательщика", "ДокументооборотСКОВызовСервера.УстановитьПараметрСеансаТекущиеУчетныеЗаписиНалогоплательщика");
	Обработчики.Вставить("ТекущийСеансДокументооборотаСКО", "ДокументооборотСКО.УстановитьПараметрСеансаТекущийСеансДокументооборотаСКО");
	Обработчики.Вставить("СостояниеДлительнойОтправки", "ДлительнаяОтправка.ПриУстановкеПараметровСеанса");
	// Конец Электронный документооборот с контролирующими органами
	
	Обработчики.Вставить("ПараметрыВнешнихРегламентированныхОтчетов", "РегламентированнаяОтчетностьВызовСервера.УстановитьПараметрыВнешнихРегламентированныхОтчетов");
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию программных интерфейсов,
// используя в качестве ключей имена программных интерфейсов.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
//   СтруктураПоддерживаемыхВерсий - Структура - структура поддерживаемых версий:
//     * Ключ - Строка - имя программного интерфейса,
//     * Значение - Массив(Строка) - поддерживаемые версии программного интерфейса.
//
// Пример:
//   // СервисПередачиФайлов
//   МассивВерсий = Новый Массив;
//   МассивВерсий.Добавить("1.0.1.1");
//   МассивВерсий.Добавить("1.0.2.1"); 
//   СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//   // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий) Экспорт
	
	// СервисФормированияМЧБсPDF417
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.1.1");
	МассивВерсий.Добавить("1.0.1.2");
	СтруктураПоддерживаемыхВерсий.Вставить("СервисФормированияМЧБсPDF417", МассивВерсий);
	// Конец СервисФормированияМЧБсPDF417
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при запуске.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат;
	КонецЕсли;
	
	ДокументооборотСКО.ПараметрыРаботыКлиентаПриЗапуске(Параметры);

КонецПроцедуры

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий.
//
// Параметры:
//   СоответствиеИменПсевдонимам - Соответствие - соответствие имен:
//     * Ключ - Строка - псевдоним метода, например, "ОчиститьОбластьДанных".
//     * Значение - Строка - имя метода для вызова, например, РаботаВМоделиСервиса.ОчиститьОбластьДанных.
//                           В качестве значения можно указать Неопределено, в этом случае считается,
//                           что имя совпадает с псевдонимом.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	ДокументооборотСКО.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьВБанки") Тогда
		МодульОтчетностьВБанкиСлужебный = ОбщегоНазначения.ОбщийМодуль("ОтчетностьВБанкиСлужебный");
		МодульОтчетностьВБанкиСлужебный.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	КонецЕсли;
	
КонецПроцедуры

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций.
//  - возможность выполнения в различных режимах работы программы.
//  - прочие параметры.
//
// Параметры:
//  Настройки - ТаблицаЗначений - таблица значений с колонками:
//    * РегламентноеЗадание - ОбъектМетаданных:РегламентноеЗадание - регламентное задание.
//    * ФункциональнаяОпция - ОбъектМетаданных:ФункциональнаяОпция - функциональная опция,
//        от которой зависит регламентное задание.
//    * ЗависимостьПоИ      - Булево - если регламентное задание зависит более, чем
//        от одной функциональной опции и его необходимо включать только тогда,
//        когда все функциональные опции включены, то следует указывать Истина
//        для каждой зависимости.
//        По умолчанию Ложь - если хотя бы одна функциональная опция включена,
//        то регламентное задание тоже включено.
//    * ВключатьПриВключенииФункциональнойОпции - Булево, Неопределено - если Ложь, то при
//        включении функциональной опции регламентное задание не будет включаться. Значение
//        Неопределено соответствует значению Истина.
//        По умолчанию - неопределено.
//    * ДоступноВПодчиненномУзлеРИБ - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в РИБ.
//        По умолчанию - неопределено.
//    * ДоступноВАвтономномРабочемМесте - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в автономном рабочем месте.
//        По умолчанию - неопределено.
//    * ДоступноВМоделиСервиса      - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в модели сервиса.
//        По умолчанию - неопределено.
//    * РаботаетСВнешнимиРесурсами  - Булево - Истина, если регламентное задание модифицирует данные
//        во внешних источниках (получение почты, синхронизация данных и т.п.).
//        По умолчанию - Ложь.
//    * Параметризуется             - Булево - Истина, если регламентное задание параметризованное.
//        По умолчанию - Ложь.
//
// Например:
//	Настройка = Настройки.Добавить();
//	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСтатусовДоставкиSMS;
//	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
//	Настройка.ДоступноВМоделиСервиса = Ложь;
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	ДокументооборотСКО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ОнлайнСервисыРегламентированнойОтчетности.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьВБанки") Тогда
		МодульОтчетностьВБанкиСлужебный = ОбщегоНазначения.ОбщийМодуль("ОтчетностьВБанкиСлужебный");
		МодульОтчетностьВБанкиСлужебный.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
