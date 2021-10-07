﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет настроить общие параметры подсистемы.
//
// Параметры:
//  ОбщиеПараметры - Структура - структура со свойствами:
//      * ИмяФормыПерсональныхНастроек            - Строка - имя формы для редактирования персональных настроек.
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ИмяФормыПерсональныхНастроек.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить в Ложь, то 
//                                                                  подтверждение при завершении работы программы не
//                                                                  будет запрашиваться,  если явно не разрешить в
//                                                                  персональных настройках программы.
//      * МинимальнаяВерсияПлатформы              - Строка - минимальная версии платформы, требуемая для запуска программы.
//                                                           Запуск программы на версии платформы ниже указанной будет невозможен.
//                                                           Например, "8.3.6.1650".
//      * РекомендуемаяВерсияПлатформы            - Строка - рекомендуемая версия платформы для запуска программы.
//                                                           Например, "8.3.8.2137".
//      * ОтключитьИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочников ИдентификаторыОбъектовМетаданных
//              и ИдентификаторыОбъектовРасширений, процедуру выгрузки и загрузки в узлах РИБ.
//              Для частичного встраивания отдельных функций библиотеки в конфигурации без постановки на поддержку.
//      * РекомендуемыйОбъемОперативнойПамяти - Число - объем памяти в гигабайтах, рекомендуемый для комфортной работы в
//                                                      программе.
//
//    Устарели, следует использовать свойства МинимальнаяВерсияПлатформы и РекомендуемаяВерсияПлатформы:
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы.
//                                                           Например, "8.3.4.365".
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ПолучитьМинимальноНеобходимуюВерсиюПлатформы.
//      * РаботаВПрограммеЗапрещена               - Булево - начальное значение Ложь.
//
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	ОбщиеПараметры.РекомендуемаяВерсияПлатформы = "8.3.15.1830";
	ОбщиеПараметры.РекомендуемыйОбъемОперативнойПамяти = 3;
	
КонецПроцедуры

// Определяет соответствие имен параметров сеанса и обработчиков для их установки.
// Вызывается для инициализации параметров сеанса из обработчика события модуля сеанса УстановкаПараметровСеанса
// (подробнее о нем см. синтакс-помощник).
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры:
//  ИмяПараметра           - Строка - имя параметра сеанса, который требуется установить.
//  УстановленныеПараметры - Массив - имена параметров, которые уже установлены.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
//// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
//Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
//	
//	Если ИмяПараметра = "ТекущийПользователь" Тогда
//		ПараметрыСеанса.ТекущийПользователь = Значение;
//		УстановленныеПараметры.Добавить("ТекущийПользователь");
//	КонецЕсли;
//	
//КонецПроцедуры
//
// Параметры:
//  Обработчики - Соответствие - со свойствами:
//    * Ключ     - Строка - в формате "<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>".
//                   Символ '*'используется в конце имени параметра сеанса и обозначает,
//                   что один обработчик будет вызван для инициализации всех параметров сеанса
//                   с именем, начинающимся на слово НачалоИмениПараметраСеанса.
//
//    * Значение - Строка - в формате "<ИмяМодуля>.УстановкаПараметровСеанса".
//
//  Пример:
//   Обработчики.Вставить("ТекущийПользователь", "ПользователиСлужебный.УстановкаПараметровСеанса");
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	//ПодключаемоеОборудование
	Обработчики.Вставить("РабочееМестоКлиента", "МенеджерОборудованияВызовСервера.УстановитьПараметрыСеансаПодключаемогоОборудования");
	//Конец ПодключаемоеОборудование
	
	//РегламентированнаяОтчетность
	ОбщегоНазначенияБРО.ОбработчикиИнициализацииПараметровСеанса(Обработчики);
	//Конец РегламентированнаяОтчетность
	
	// бит_Финанс Изменение кода. Начало.
	Обработчики.Вставить("бит_*","бит_ПолныеПрава.ЗаполнитьПараметрыСеанса");	
	// бит_Финанс Изменение кода. Конец.
	
	// ЕГАИС
	Обработчики.Вставить("ИдентификаторСеансаЕГАИС" , "ИнтеграцияЕГАИС.УстановитьПараметрыСеанса");
	// Конец ЕГАИС
	
	Обработчики.Вставить("РазрешенныеРазделыМонитораРуководителя" , "МониторРуководителя.УстановитьРазрешенныеРазделыМонитораРуководителя");
	
	Обработчики.Вставить("РазрешенныеПользователюРазделыПерсонализированныхДанных" , "ПерсонализированныеПредложенияСервисов.УстановитьРазрешенныеПользователюРазделыПерсонализированныхДанных");

	Обработчики.Вставить("СтатистикаОткрытияФорм", "ОбщегоНазначенияБП.УстановитьСтатистикуОткрытияФорм");
	
	//ИнтеграцияС1СДокументооборот
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборот = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияС1СДокументооборот");
		МодульИнтеграцияС1СДокументооборот.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	КонецЕсли;
	//Конец ИнтеграцияС1СДокументооборот
	
	// БиблиотекаЭлектронныхДокументов
	ЭлектронноеВзаимодействие.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец БиблиотекаЭлектронныхДокументов
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ОбщегоНазначенияБП.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	
	ОбщегоНазначенияБРО.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	// бит_Финанс изменения кода. Начало.
	бит_ОбщегоНазначения.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	// бит_Финанс изменения кода. Конец.
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// Для получения этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента, которые необходимо задать.
//                           Для установки параметров работы клиента:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	ОбщегоНазначенияБП.ПриДобавленииПараметровРаботыКлиента(Параметры);
	
КонецПроцедуры

// Определяет объекты метаданных и отдельные реквизиты, которые исключаются из результатов поиска ссылок,
// не учитываются при монопольном удалении помеченных, замене ссылок и в отчете по местам использования.
// См. также ОбщегоНазначения.ИсключенияПоискаСсылок.
//
// Пример задачи: к документу "Реализация товаров и услуг" подключены подсистемы "Версионирование объектов" и "Свойства".
// Также этот документ может быть указан в других объектах метаданных - документах или регистрах.
// Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
// Другая часть ссылок - "техногенные" (ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства")
// и должны скрываться от пользователя при удалении, анализе мест использования или запретов редактирования ключевых реквизитов.
// Список таких "техногенных" объектов нужно перечислить в этой процедуре.
//
// При этом для избежания появления ссылок на несуществующие объекты
// рекомендуется предусмотреть процедуру очистки указанных объектов метаданных.
//   * Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   * Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов
//     метаданных, которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать, как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
// Подробнее см. в документации к подсистеме "Удаление помеченных объектов".
//
// При исключении регистров допустимо исключать только Измерения.
// При необходимости исключить из поиска значения в ресурсах
// или в реквизитах регистров требуется исключить регистр целиком.
//
// Параметры:
//   ИсключенияПоискаСсылок - Массив - объекты метаданных или их реквизиты (ОбъектМетаданных, Строка),
//       которые не должно учитываться в бизнес-логике.
//       Стандартные реквизиты и табличные части могут быть указаны только в виде строковых имен (см. пример ниже).
//
// Пример:
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Измерения.Объект);
//   ИсключенияПоискаСсылок.Добавить("ПланВидовРасчета._ДемоОсновныеНачисления.СтандартнаяТабличнаяЧасть.БазовыеВидыРасчета.СтандартныйРеквизит.ВидРасчета");
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.КлючиАналитикиУчетаЗатрат);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.КлючиАналитикиУчетаНДС);
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.АналитикаУчетаЗатрат);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.АналитикаУчетаНДС);
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.БезопасноеХранилищеДанныхОбщее.Измерения.Владелец);
	
КонецПроцедуры

// Вызывается при обновлении информационной базы для учета переименований подсистем и ролей в конфигурации.
// В противном случае, возникнет рассинхронизация между метаданными конфигурации и 
// элементами справочника ИдентификаторыОбъектовМетаданных, что приведет к различным ошибкам при работе конфигурации.
// См. также ОбщегоНазначения.ИдентификаторОбъектаМетаданных, ОбщегоНазначения.ИдентификаторыОбъектовМетаданных.
//
// В этой процедуре последовательно для каждой версии конфигурации задаются переименования только подсистем и ролей, 
// а переименования остальных объектов метаданных задавать не следует, т.к. они обрабатываются автоматически.
//
// Параметры:
//  Итог - ТаблицаЗначений - таблица переименований, которую требуется заполнить.
//                           См. ОбщегоНазначения.ДобавитьПереименование.
//
// Пример:
//	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.1.2.14",
//		"Подсистема._ДемоПодсистемы",
//		"Подсистема._ДемоСервисныеПодсистемы");
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = Метаданные.Имя;
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ХозяйственныеОперации",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ВедениеУчета",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыФормированияОтчетныхДанных",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыФормированияОтчетныхДанных",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыПромежуточныхРасчетов",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыПромежуточныхРасчетов",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыУчетаСостоянияЕдиницыНалоговогоУчета",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаСостоянияЕдиницыНалоговогоУчета",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыУчетаХозяйственныхОпераций",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаХозяйственныхОпераций",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		Библиотека);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя",
		"Подсистема.Руководителю",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		"Подсистема.Руководителю.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.ДенежныеСредства",
		"Подсистема.Руководителю.Подсистема.ДенежныеСредства",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		"Подсистема.Руководителю.Подсистема.РасчетыСПокупателями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		"Подсистема.Руководителю.Подсистема.РасчетыСПоставщиками",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.ОбщиеПоказатели",
		"Подсистема.Руководителю.Подсистема.ОбщиеПоказатели",
		Библиотека);
		
	// В версии 3.0.44.14 обновлена библиотека ИнтеграцияЕГАИС, в которой переименована роль
	// Библиотека еще не обрабатывает это переименование, поэтому оно обработано на стороне прикладного решения
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"3.0.44.14",
		"Роль.ВыполнениеСинхронизацииСЕГАИС",
		"Роль.БазовыеПраваЕГАИС",
		"ИнтеграцияЕГАИС");
		
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"3.0.57.3",
		"Роль.ЧтениеДанныхПерсонализированныхДанных",
		"Роль.ЧтениеПерсонализированныхДанных",
		Библиотека);

	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ДополнительныеОбъектыБиблиотекБП",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ДополнительныеОбъектыБиблиотекБП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ЕНВД",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ЕНВД",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ИнтеграцияГИСМБП",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ИнтеграцияГИСМБП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ИнформационнаяПанель",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ИнформационнаяПанель",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.МониторингБанков",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.МониторингБанков",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ОбменБухгалтерия3Зарплата3",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ОбменБухгалтерия3Зарплата3",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ОбменДаннымиСТиС",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ОбменДаннымиСТиС",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ОбменСИнтернетМагазином",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ОбменСИнтернетМагазином",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ОбменСМобильнымиПриложениями",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ОбменСМобильнымиПриложениями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ДополнительныеОбъектыБиблиотекБП",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ДополнительныеОбъектыБиблиотекБП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ОтложенноеПроведение",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ОтложенноеПроведение",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ОтправкаПочтовыхСообщений",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ОтправкаПочтовыхСообщений",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПерсонализированныеПредложенияСервисов",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПерсонализированныеПредложенияСервисов",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПрисоединенныеФайлыБП",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПрисоединенныеФайлыБП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПроверкаКонтрагентов",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПроверкаКонтрагентов",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.РегистрацияОрганизаций",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.РегистрацияОрганизаций",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПростойИнтерфейс",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПростойИнтерфейс",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПростойИнтерфейс.Подсистема.Отчеты",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПростойИнтерфейс.Подсистема.Отчеты",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПростойИнтерфейс.Подсистема.Отчеты.Подсистема.СправкиРасчеты",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПростойИнтерфейс.Подсистема.Отчеты.Подсистема.СправкиРасчеты",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.ПростойИнтерфейс.Подсистема.Отчеты.Подсистема.РегистрыБУСубъектовМалогоПредпринимательства",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.ПростойИнтерфейс.Подсистема.Отчеты.Подсистема.РегистрыБУСубъектовМалогоПредпринимательства",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.СверкаДанныхУчетаНДС",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.СверкаДанныхУчетаНДС",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.УчетнаяПолитика",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.УчетнаяПолитика",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Прибыль",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Прибыль",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.УСН",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.УСН",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.НДС",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.НДС",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.ЕНВД",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.ЕНВД",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Патенты",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Патенты",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.ТорговыйСбор",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.ТорговыйСбор",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Предприниматель",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Предприниматель",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Имущество",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Имущество",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Земля",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Земля",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Транспорт",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетнаяПолитикаНалогиИОтчеты.Подсистема.СистемаНалогообложения.Подсистема.Транспорт",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.СтатистикаПоПоказателям",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.СтатистикаПоПоказателям",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.СтатусыДокументов",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.СтатусыДокументов",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.59.29",
		"Подсистема.УчетСтраховыхВзносовИП",
		"Подсистема.БухгалтерияПредприятияПодсистемы.Подсистема.УчетСтраховыхВзносовИП",
		Библиотека);
		
	УчетОбособленныхПодразделений.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	
	// БЗКБ
	ЗарплатаКадры.ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог);
	
	// БЭД
	ЭлектронноеВзаимодействие.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	
	// бит_Финанс изменения кода. Начало. ++ БП
	бит_ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	// бит_Финанс изменения кода. Конец. -- БП
	
КонецПроцедуры

// Позволяет отключать подсистемы, например, для целей тестирования.
// Если подсистема отключена, то функции ОбщегоНазначения.ПодсистемаСуществует и 
// ОбщегоНазначенияКлиент.ПодсистемаСуществует вернут Ложь.
//
// В реализации этой процедуры нельзя использовать функцию ОбщегоНазначения.ПодсистемСуществует, 
// т.к. это приводит к рекурсии.
//
// Параметры:
//   ОтключенныеПодсистемы - Соответствие - в ключе указывается имя отключаемой подсистемы, 
//                                          в значении - установить в Истина.
//
Процедура ПриОпределенииОтключенныхПодсистем(ОтключенныеПодсистемы) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед загрузкой приоритетных данных в подчиненном узле РИБ
// и предназначена для заполнения настроек размещения сообщения обмена данными или
// для реализации нестандартной загрузки приоритетных данных из главного узла РИБ.
//
// К приоритетным данным относятся предопределенные элементы, а также
// элементы справочника ИдентификаторыОбъектовМетаданных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - начальное значение Истина; если установить Ложь, 
//                то стандартная загрузка приоритетных данных с помощью подсистемы
//                ОбменДанными будет пропущена (так же будет и в том случае,
//                если подсистемы ОбменДанными нет в конфигурации).
//
Процедура ПередЗагрузкойПриоритетныхДанныхВПодчиненномРИБУзле(СтандартнаяОбработка) Экспорт
	
	ГлавныйУзел = ПланыОбмена.ГлавныйУзел();
	Если ЗначениеЗаполнено(ГлавныйУзел) Тогда 
		ОбменДаннымиОбновлениеСПредыдущейРедакции.ПеренестиНастройкиОбменаДанными(ГлавныйУзел, ГлавныйУзел);
	КонецЕсли;
	
КонецПроцедуры

// Определяет список версий программных интерфейсов, доступных через web-сервис InterfaceVersion.
// См. также ОбщегоНазначения.ВерсииИнтерфейса.
//
// Параметры:
//  ПоддерживаемыеВерсии - Структура - в ключе указывается имя программного интерфейса,
//                                     а в значениях - массив строк с поддерживаемыми версиями этого интерфейса.
//
// Пример:
//
//  // СервисПередачиФайлов
//  Версии = Новый Массив;
//  Версии.Добавить("1.0.1.1");
//  Версии.Добавить("1.0.2.1"); 
//  ПоддерживаемыеВерсии.Вставить("СервисПередачиФайлов", Версии);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии) Экспорт
	
	//РегламентированнаяОтчетность
	ОбщегоНазначенияБРО.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии);
	// Конец РегламентированнаяОтчетность
	
	// СтатистикаПоПоказателям
	СтатистикаПоПоказателямСлужебный.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии);
	// Конец СтатистикаПоПоказателям
	
КонецПроцедуры

// Задает параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
// Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
// то параметры функциональных опций могут определять условия отборов по измерениям регистра,
// которые будут применяться при чтении значения этой функциональной опции.
//
// См. в синтакс-помощнике методы ПолучитьФункциональнуюОпциюИнтерфейса,
// УстановитьПараметрыФункциональныхОпцийИнтерфейса и ПолучитьПараметрыФункциональныхОпцийИнтерфейса.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики отправки и получения данных для обмена в распределенной информационной базе.

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник                  - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных             - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента          - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  СозданиеНачальногоОбраза  - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхПодчиненному(Источник, ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента  - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхГлавному(Источник, ЭлементДанных, ОтправкаЭлемента) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтПодчиненного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтГлавного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

#КонецОбласти
