﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//	 * ПараметрыУказанияСерий - Структура - состав полей задается в функции ПроверкаИПодборПродукцииИСМП.ПараметрыУказанияСерий
//	Возвращаемое значение:
//	 * ТекстЗапроса - Строка - текст запроса расчета статуса указания серий.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(
		Метаданные.Обработки.ВиртуальнаяАгрегацияУпаковокИСМП, ПараметрыУказанияСерий);
	
КонецФункции

#КонецОбласти

	
#Область СлужебныйПрограммныйИнтерфейс

// Вызывается из длительной операции по подготовке данных для формы проверки и подбора табачной продукции.
// 
// Параметры:
//	* Параметры - Структура - содержит следующие значения:
// 		** ПроверкаНеПоДокументу            - Булево - признак получения данных не по ссылке на документ
// 		** ПроверяемыйДокумент              - ДокументСсылка - ссылка на документ, из формы которого открыта форма проверки и подбора
// 		** НачальныйСтатусПроверки          - ПеречислениеСсылка.СтатусыПроверкиНаличияПродукцииИС - статус наличия продукции, используемый при подготовке данных
// 		** ДетализацияСтруктурыХранения     - ПеречислениеСсылка.ДетализацияСтруктурыХраненияТабачнойПродукцииМОТП - значение детализации из формы проверки
// 		** РедактированиеФормыНедоступно    - Булево - признак запрета редактирования формы подбора
// 		** РежимПодбораСуществующихУпаковок - Булево - признак работы со штрихкодами упаковок, имеющимися в информационной базе
// 		** ПараметрыСканирования            - Структура - параметры обработки кодов маркировки, сформированные в форме проверки и подбора
// 		** ПараметрыПроверкиКодовМаркировки - Структура - параметры проверки кодов маркировки по статусу и владельцу, сформированные в форме проверки и подбора
// 		** КонтролироватьСканируемуюПродукциюПоДокументуОснованию - Булево - признак необходимости контроля наличия табачной продукции по основанию проверяемого документа
//	* АдресРезультата - Строка - адрес временного хранилища, в которое будут помещены результаты выполнения
// Возвращаемое значение:
//
Процедура ПолучитьДанныеЗаполнения(Параметры, АдресРезультата) Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("ОстаткиПродукции",           НоваяОстаткиПродукции());
	ДанныеЗаполнения.Вставить("СуществующиеУпаковки",       НовоеДеревоУпаковок());
	ДанныеЗаполнения.Вставить("СписокИсторическихУпаковок", Новый СписокЗначений());
	ДанныеЗаполнения.Вставить("СоставИсторическихУпаковок", НовоеСоставИсторическихУпаковок());
	
	ЗаполнитьОстаткиПродукцииПоДокументу(Параметры, ДанныеЗаполнения);
	ЗаполнитьСоставИсторическихУпаковок(Параметры, ДанныеЗаполнения);
	РегистрыСведений.ПулКодовМаркировкиСУЗ.ЗаполнитьДеревоСуществующихУпаковокПоДокументу(
		ДанныеЗаполнения.СуществующиеУпаковки, Параметры.Документ, Параметры.ВидПродукции, Ложь);
	
	ПоместитьВоВременноеХранилище(ДанныеЗаполнения, АдресРезультата);

КонецПроцедуры

// Вызывается из длительной операции по подготовке данных для формы проверки и подбора табачной продукции.
// 
// Параметры:
//  * Параметры - Структура - содержит следующие значения:
//   ** Документ - ДокументСсылка - ссылка на документ, на основании данных которого выполняется виртуальная агрегация
//   ** ХешСуммаУпаковки - Строка - хеш сумма состава удаляемых логистических упаковок
//  * АдресРезультата - Строка - адрес временного хранилища, в которое будут помещены результаты выполнения
//
Процедура УдалитьУпаковки(Параметры, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоЗаказНаЭмиссию = ТипЗнч(Параметры.Документ) = Тип("ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ");

	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПулКодовМаркировкиСУЗ");
		ЭлементБлокировки.УстановитьЗначение(?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование"), Параметры.Документ);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекстЗапроса = "
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
		|ГДЕ
		|	ПулКодовМаркировки." + ?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование") + " = &Документ
		|	И ПулКодовМаркировки.ХешСуммаУпаковки = &ХешСуммаУпаковки
		|	И ПулКодовМаркировки.ДатаПечатиУниверсальная <> ДАТАВРЕМЯ(1, 1, 1)
		|";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Документ", Параметры.Документ);
		Запрос.УстановитьПараметр("ХешСуммаУпаковки", Параметры.ХешСуммаУпаковки);
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			ТекстОшибки = НСтр("ru = 'Нельзя удалять упаковки, для которых уже распечатаны коды маркировки.'");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ПулКодовМаркировкиСУЗ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор[?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование")].Установить(Параметры.Документ);
		НаборЗаписей.Прочитать();
		
		Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
			Если ЗаписьНабора.ХешСуммаУпаковки = Параметры.ХешСуммаУпаковки Тогда
				ЗаписьНабора.ШтрихкодУпаковки = Неопределено;
				ЗаписьНабора.ХешСуммаУпаковки = "";
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
	
	Исключение
	
		ОтменитьТранзакцию();
		
		ТекстОшибки = НСтр("ru = 'Произошла ошибка при удалении сформированных упаковок.'");
		ТекстОшибки = ТекстОшибки + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВызватьИсключение ТекстОшибки;
	
	КонецПопытки;
		
КонецПроцедуры

// Вызывается из длительной операции по подготовке данных для формы проверки и подбора табачной продукции.
// 
// Параметры:
//  * Параметры - Структура - содержит следующие значения:
//   ** Документ - ДокументСсылка - ссылка на документ, на основании данных которого выполняется виртуальная агрегация
//   ** ДеревоУпаковок - ДеревоЗначений - сформированные в форме логистические упаковки
//  * АдресРезультата - Строка - адрес временного хранилища, в которое будут помещены результаты выполнения.
//
Процедура ЗаписатьУпаковки(Параметры, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	ЭтоЗаказНаЭмиссию = ТипЗнч(Параметры.Документ) = Тип("ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ");

	Попытка
		
		ТаблицаАгрегаций = Параметры.ТаблицаАгрегаций;
		ТаблицаАгрегаций.Колонки.Добавить("СтрокиУпаковок",   Новый ОписаниеТипов("Массив"));
		ТаблицаАгрегаций.Колонки.Добавить("ХешСуммаУпаковки", ОбщегоНазначения.ОписаниеТипаСтрока(50));
		
		ДеревоУпаковок     = НовоеДеревоУпаковок();
		СоставВсехУпаковок = НоваяСоставУпаковки();
		
		СерийныеНомераПоТипамШтрихкода = Новый Соответствие();
		
		Для Каждого СтрокаАгрегации Из ТаблицаАгрегаций Цикл
			КоличествоВУпаковке = СтрокаАгрегации.СоставУпаковок.Итог("Количество");
			ХешСуммаУпаковки    = ХешСуммаУпаковки(СтрокаАгрегации.СоставУпаковок);
			
			Если СтрокаАгрегации.СоставУпаковок.Количество() = 1 Тогда
				ТипУпаковки = Перечисления.ТипыУпаковок.МонотоварнаяУпаковка;
			Иначе
				ТипУпаковки = Перечисления.ТипыУпаковок.МультитоварнаяУпаковка;
			КонецЕсли;
			
			НоменклатураУпаковки   = Null;
			ХарактеристикаУпаковки = Null;
			СерияУпаковки          = Null;
			
			Для Каждого СтрокаСостава Из СтрокаАгрегации.СоставУпаковок Цикл
				НоваяСтрока = СоставВсехУпаковок.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСостава);
				НоваяСтрока.Количество = НоваяСтрока.Количество * СтрокаАгрегации.КоличествоУпаковок;
				
				РассчитатьИтогЭлементаСоставаУпаковки(НоменклатураУпаковки,   СтрокаСостава.Номенклатура);
				РассчитатьИтогЭлементаСоставаУпаковки(ХарактеристикаУпаковки, СтрокаСостава.Характеристика);
				РассчитатьИтогЭлементаСоставаУпаковки(СерияУпаковки,          СтрокаСостава.Серия);
			КонецЦикла;
			
			СтрокиУпаковок = Новый Массив();
			
			Для НомерУпаковки = 1 По СтрокаАгрегации.КоличествоУпаковок Цикл
				СтрокаУпаковки = ДеревоУпаковок.Строки.Добавить();
				СтрокаУпаковки.Количество       = КоличествоВУпаковке;
				СтрокаУпаковки.ХешСуммаУпаковки = ХешСуммаУпаковки;
				СтрокаУпаковки.ТипУпаковки      = ТипУпаковки;
				СтрокаУпаковки.ТипШтрихкода     = СтрокаАгрегации.ТипШтрихкода;
				СтрокаУпаковки.Номенклатура     = НоменклатураУпаковки;
				СтрокаУпаковки.Характеристика   = ХарактеристикаУпаковки;
				СтрокаУпаковки.Серия            = СерияУпаковки;
				СтрокаУпаковки.Штрихкод         = НовыйШтрихкод(СтрокаАгрегации.ТипШтрихкода,
					СтрокаАгрегации.КлючНумератора, СерийныеНомераПоТипамШтрихкода);
				СтрокиУпаковок.Добавить(СтрокаУпаковки);
			КонецЦикла;
			
			СтрокаАгрегации.СтрокиУпаковок   = СтрокиУпаковок;
			СтрокаАгрегации.ХешСуммаУпаковки = ХешСуммаУпаковки;
		КонецЦикла;
	
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПулКодовМаркировкиСУЗ");
		ЭлементБлокировки.УстановитьЗначение(?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование"), Параметры.Документ);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	СоставУпаковок.Номенклатура   КАК Номенклатура,
		|	СоставУпаковок.Характеристика КАК Характеристика,
		|	СоставУпаковок.Количество     КАК Количество
		|ПОМЕСТИТЬ
		|	ВТТаблицаСостава
		|ИЗ
		|	&СоставУпаковок КАК СоставУпаковок
		|
		|;
		|
		|ВЫБРАТЬ
		|	ТаблицаСостава.Номенклатура      КАК Номенклатура,
		|	ТаблицаСостава.Характеристика    КАК Характеристика,
		|	СУММА(ТаблицаСостава.Количество) КАК Количество
		|ПОМЕСТИТЬ
		|	ВТСоставУпаковок
		|ИЗ
		|	ВТТаблицаСостава КАК ТаблицаСостава
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаСостава.Номенклатура,
		|	ТаблицаСостава.Характеристика
		|ИМЕЮЩИЕ
		|	СУММА(ТаблицаСостава.Количество) > 0
		|
		|;
		|
		|ВЫБРАТЬ
		|	ПулКодовМаркировки.КодМаркировки  КАК КодМаркировки,
		|	ПулКодовМаркировки.Номенклатура   КАК Номенклатура,
		|	ПулКодовМаркировки.Характеристика КАК Характеристика,
		|	СоставУпаковок.Количество         КАК Количество,
		|	1                                 КАК КоличествоКодов,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПулКодовМаркировки.Номенклатура)   КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПулКодовМаркировки.Характеристика) КАК ХарактеристикаПредставление
		|ИЗ
		|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСоставУпаковок КАК СоставУпаковок
		|		ПО ПулКодовМаркировки.Номенклатура = СоставУпаковок.Номенклатура
		|		 И ПулКодовМаркировки.Характеристика = СоставУпаковок.Характеристика
		|ГДЕ
		|	ПулКодовМаркировки." + ?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование") + " = &Документ
		|	И НЕ ПулКодовМаркировки.Статус В (&СтатусыВыведенИзОборота)
		|	И ПулКодовМаркировки.ШтрихкодУпаковки = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
		|ИТОГИ
		|	МАКСИМУМ(Количество),
		|	СУММА(КоличествоКодов)
		|ПО
		|	Номенклатура,
		|	Характеристика
		|";
		
		Запрос = Новый Запрос();
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Документ", Параметры.Документ);
		Запрос.УстановитьПараметр("СоставУпаковок", СоставВсехУпаковок);
		Запрос.УстановитьПараметр("СтатусыВыведенИзОборота", РегистрыСведений.ПулКодовМаркировкиСУЗ.СтатусыВыведенИзОборота());
		Результат = Запрос.Выполнить();
		
		СоответствиеКодовМаркировкиСтрокамУпаковок = Новый Соответствие();
		
		ВыборкаНоменклатура = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНоменклатура.Следующий() Цикл
			
			ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаХарактеристика.Следующий() Цикл
				
				Если ВыборкаХарактеристика.Количество > ВыборкаХарактеристика.КоличествоКодов Тогда
					ТекстОшибки = НСтр("ru = 'Количества кодов маркировки (%1) по номенклатуре ""%2"" недостаточно для формирования %3 упаковок'");
					ТекстОшибки = СтрШаблон(ТекстОшибки,
						ВыборкаХарактеристика.КоличествоКодов,
						ИнтеграцияИС.ПредставлениеНоменклатуры(ВыборкаХарактеристика.НоменклатураПредставление, ВыборкаХарактеристика.ХарактеристикаПредставление),
						Параметры.КоличествоУпаковок);
					ВызватьИсключение ТекстОшибки;
				КонецЕсли;
				
				СтруктураПоиска = Новый Структура("Номенклатура,Характеристика");
				ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыборкаХарактеристика);
				
				Выборка = ВыборкаХарактеристика.Выбрать();
				
				Для Каждого СтрокаАгрегации Из ТаблицаАгрегаций Цикл
					СтрокиСостава = СтрокаАгрегации.СоставУпаковок.НайтиСтроки(СтруктураПоиска);
					Если СтрокиСостава.Количество() = 0 Тогда
						Продолжить;
					КонецЕсли;
					
					Для Каждого СтрокаУпаковки Из СтрокаАгрегации.СтрокиУпаковок Цикл
						Для Каждого СтрокаСостава Из СтрокиСостава Цикл
							Для НомерЭкземпляра = 1 По СтрокаСостава.Количество Цикл
								СтрокаПродукции = СтрокаУпаковки.Строки.Добавить();
								СтрокаПродукции.ТипУпаковки  = Перечисления.ТипыУпаковок.МаркированныйТовар;
								СтрокаПродукции.ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_DataMatrix;
								ЗаполнитьЗначенияСвойств(СтрокаПродукции, СтрокаСостава, "Номенклатура,Характеристика,Серия");
								
								Выборка.Следующий();
								
								СтрокаПродукции.Штрихкод   = Выборка.КодМаркировки;
								СтрокаПродукции.Количество = 1;
								
								СоответствиеКодовМаркировкиСтрокамУпаковок.Вставить(Выборка.КодМаркировки, СтрокаУпаковки);
							КонецЦикла;
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		Справочники.ШтрихкодыУпаковокТоваров.СоздатьШтрихкодыУпаковокПоДаннымДерева(ДеревоУпаковок);
		
		НаборЗаписей = РегистрыСведений.ПулКодовМаркировкиСУЗ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор[?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование")].Установить(Параметры.Документ);
		НаборЗаписей.Прочитать();
		
		Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
			СтрокаУпаковки = СоответствиеКодовМаркировкиСтрокамУпаковок[ЗаписьНабора.КодМаркировки];
			Если СтрокаУпаковки <> Неопределено Тогда
				ЗаписьНабора.ШтрихкодУпаковки = СтрокаУпаковки.ШтрихкодУпаковки;
				ЗаписьНабора.ХешСуммаУпаковки = СтрокаУпаковки.ХешСуммаУпаковки;
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
	
	Исключение
	
		ОтменитьТранзакцию();
		
		ТекстОшибки = НСтр("ru = 'Произошла ошибка при записи сформированных упаковок.'");
		ТекстОшибки = ТекстОшибки + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВызватьИсключение ТекстОшибки;
	
	КонецПопытки;
	
	ТаблицаАгрегаций.Колонки.Удалить("КоличествоУпаковок");
	ТаблицаАгрегаций.Колонки.Удалить("СоставУпаковок");
	ТаблицаАгрегаций.Колонки.Удалить("СтрокиУпаковок");
	ТаблицаАгрегаций.Колонки.Удалить("КлючНумератора");
	ТаблицаАгрегаций.Колонки.Удалить("ТипШтрихкода");
	
	ПоместитьВоВременноеХранилище(ТаблицаАгрегаций, АдресРезультата);
	
КонецПроцедуры

Функция ХешСуммаУпаковки(СоставУпаковки) Экспорт
	
	ДанныеХешСуммыУпаковки = Новый СписокЗначений();
	
	Для Каждого СтрокаСостава Из СоставУпаковки Цикл
		ДанныеХешСуммыСтроки = Новый Массив();
		ДанныеХешСуммыСтроки.Добавить(Строка(СтрокаСостава.Номенклатура.УникальныйИдентификатор()));
		
		Если ЗначениеЗаполнено(СтрокаСостава.Характеристика) Тогда
			ДанныеХешСуммыСтроки.Добавить(Строка(СтрокаСостава.Характеристика.УникальныйИдентификатор()));
		КонецЕсли;
		
		ДанныеХешСуммыСтроки.Добавить(Формат(СтрокаСостава.Количество, "ЧДЦ=0; ЧРГ=;"));
		ДанныеХешСуммыУпаковки.Добавить(СтрСоединить(ДанныеХешСуммыСтроки));
	КонецЦикла;
	
	Возврат Справочники.ШтрихкодыУпаковокТоваров.ХешСуммаСодержимогоУпаковки(ДанныеХешСуммыУпаковки);
	
КонецФункции

Функция НовоеДеревоУпаковок() Экспорт
	
	ДеревоУпаковок = Новый ДеревоЗначений();
	ДеревоУпаковок.Колонки.Добавить("ТипУпаковки",      Новый ОписаниеТипов("ПеречислениеСсылка.ТипыУпаковок"));
	ДеревоУпаковок.Колонки.Добавить("ТипШтрихкода",     Новый ОписаниеТипов("ПеречислениеСсылка.ТипыШтрихкодов"));
	ДеревоУпаковок.Колонки.Добавить("Номенклатура",     Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ДеревоУпаковок.Колонки.Добавить("Характеристика",   Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ДеревоУпаковок.Колонки.Добавить("Серия",            Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ДеревоУпаковок.Колонки.Добавить("Содержимое",       Новый ОписаниеТипов("Строка"));
	ДеревоУпаковок.Колонки.Добавить("Штрихкод",         Новый ОписаниеТипов("Строка"));
	ДеревоУпаковок.Колонки.Добавить("Количество",       Новый ОписаниеТипов("Число"));
	ДеревоУпаковок.Колонки.Добавить("ШтрихкодУпаковки", Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров"));
	ДеревоУпаковок.Колонки.Добавить("ХешСуммаУпаковки", Новый ОписаниеТипов("Строка"));
	ДеревоУпаковок.Колонки.Добавить("Шаблон",
		Новый ОписаниеТипов("ПеречислениеСсылка.ШаблоныКодовМаркировкиСУЗ"));
	ДеревоУпаковок.Колонки.Добавить("СпособВводаВОборот",
		Новый ОписаниеТипов("ПеречислениеСсылка.СпособыВводаВОборотСУЗ"));
	
	Возврат ДеревоУпаковок;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОстаткиПродукцииПоДокументу(Параметры, ДанныеЗаполнения)
	
	ЭтоЗаказНаЭмиссию = ТипЗнч(Параметры.Документ) = Тип("ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ");
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПулКодовМаркировки.Номенклатура   КАК Номенклатура,
	|	ПулКодовМаркировки.Характеристика КАК Характеристика,
	|	СУММА(ВЫБОР
	|		КОГДА ПулКодовМаркировки.ШтрихкодУпаковки = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ)                            КАК Количество,
	|	СУММА(ВЫБОР
	|		КОГДА ПулКодовМаркировки.ШтрихкодУпаковки = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ)                            КАК КоличествоВУпаковках
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
	|ГДЕ
	|	ПулКодовМаркировки." + ?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование") + " = &Документ
	|	И ПулКодовМаркировки.ВидПродукции = &ВидПродукции
	|	И НЕ ПулКодовМаркировки.Статус В (&СтатусыВыведенИзОборота)
	|	И ПулКодовМаркировки.Шаблон <> Значение(Перечисление.ШаблоныКодовМаркировкиСУЗ.БлокТабачныхПачек)
	|СГРУППИРОВАТЬ ПО
	|	ПулКодовМаркировки.Номенклатура,
	|	ПулКодовМаркировки.Характеристика
	|";
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Документ",     Параметры.Документ);
	Запрос.УстановитьПараметр("ВидПродукции", Параметры.ВидПродукции);
	Запрос.УстановитьПараметр("СтатусыВыведенИзОборота", РегистрыСведений.ПулКодовМаркировкиСУЗ.СтатусыВыведенИзОборота());
	Результат = Запрос.Выполнить();
	
	НомерСтроки = 1;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ДанныеЗаполнения.ОстаткиПродукции.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Остаток = НоваяСтрока.Количество;
		НоваяСтрока.ЕстьСвободныйОстаток = НоваяСтрока.Количество > 0;
		НоваяСтрока.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСоставИсторическихУпаковок(Параметры, ДанныеЗаполнения)
	
	ЭтоЗаказНаЭмиссию = ТипЗнч(Параметры.Документ) = Тип("ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ");
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПулКодовМаркировки.Номенклатура   КАК Номенклатура,
	|	ПулКодовМаркировки.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ
	|	ВТОстаткиКодов
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
	|ГДЕ
	|	ПулКодовМаркировки." + ?(ЭтоЗаказНаЭмиссию, "ЗаказНаЭмиссию", "ДокументОснование") + " = &Документ
	|	И ПулКодовМаркировки.ВидПродукции = &ВидПродукции
	|	И НЕ ПулКодовМаркировки.Статус В (&СтатусыВыведенИзОборота)
	|	И ПулКодовМаркировки.ШтрихкодУпаковки = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	ПулКодовМаркировки.Номенклатура,
	|	ПулКодовМаркировки.Характеристика
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|
	|;
	|
	|ВЫБРАТЬ
	|	ПулКодовМаркировки.ХешСуммаУпаковки КАК ХешСуммаУпаковки
	|ПОМЕСТИТЬ
	|	ВТСуществующиеУпаковки
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
	|ГДЕ
	|	ПулКодовМаркировки.ВидПродукции = &ВидПродукции
	|	И ПулКодовМаркировки.ШтрихкодУпаковки <> ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|	И ПулКодовМаркировки.ШтрихкодУпаковки.ДатаУпаковки > &НачальнаяДатаИсторииУпаковок
	|	И (ПулКодовМаркировки.Номенклатура, ПулКодовМаркировки.Характеристика) В (
	|		ВЫБРАТЬ
	|			Номенклатура,
	|			Характеристика
	|		ИЗ
	|			ВТОстаткиКодов
	|	)
	|СГРУППИРОВАТЬ ПО
	|	ПулКодовМаркировки.ХешСуммаУпаковки
	|
	|;
	|
	|ВЫБРАТЬ
	|	ПулКодовМаркировки.ХешСуммаУпаковки КАК ХешСуммаУпаковки
	|ПОМЕСТИТЬ
	|	ВТСуществующиеТолькоИзОстатков
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСуществующиеУпаковки КАК СуществующиеУпаковки
	|		ПО ПулКодовМаркировки.ХешСуммаУпаковки = СуществующиеУпаковки.ХешСуммаУпаковки
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТОстаткиКодов КАК ОстаткиКодов
	|		ПО ПулКодовМаркировки.Номенклатура = ОстаткиКодов.Номенклатура
	|		 И ПулКодовМаркировки.Характеристика = ОстаткиКодов.Характеристика
	|ГДЕ
	|	ПулКодовМаркировки.ВидПродукции = &ВидПродукции
	|СГРУППИРОВАТЬ ПО
	|	ПулКодовМаркировки.ХешСуммаУпаковки
	|ИМЕЮЩИЕ
	|	МИНИМУМ(ВЫБОР
	|		КОГДА ОстаткиКодов.Номенклатура ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ) = ИСТИНА
	|
	|;
	|
	|ВЫБРАТЬ
	|	ПулКодовМаркировки.ХешСуммаУпаковки КАК ХешСуммаУпаковки,
	|	ПулКодовМаркировки.Номенклатура     КАК Номенклатура,
	|	ПулКодовМаркировки.Характеристика   КАК Характеристика,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПулКодовМаркировки.ШтрихкодУпаковки) = 0
	|			ТОГДА 0
	|		ИНАЧЕ КОЛИЧЕСТВО(ПулКодовМаркировки.КодМаркировки) / КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПулКодовМаркировки.ШтрихкодУпаковки)
	|	КОНЕЦ                               КАК Количество
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСуществующиеТолькоИзОстатков КАК СуществующиеУпаковки
	|		ПО ПулКодовМаркировки.ХешСуммаУпаковки = СуществующиеУпаковки.ХешСуммаУпаковки
	|ГДЕ
	|	ПулКодовМаркировки.ВидПродукции = &ВидПродукции
	|СГРУППИРОВАТЬ ПО
	|	ПулКодовМаркировки.ХешСуммаУпаковки,
	|	ПулКодовМаркировки.Номенклатура,
	|	ПулКодовМаркировки.Характеристика
	|ИТОГИ ПО
	|	ХешСуммаУпаковки
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Документ",     Параметры.Документ);
	Запрос.УстановитьПараметр("ВидПродукции", Параметры.ВидПродукции);
	Запрос.УстановитьПараметр("СтатусыВыведенИзОборота", РегистрыСведений.ПулКодовМаркировкиСУЗ.СтатусыВыведенИзОборота());
	Запрос.УстановитьПараметр("НачальнаяДатаИсторииУпаковок", ДобавитьМесяц(ТекущаяДатаСеанса(), -6));
	Результат = Запрос.Выполнить();
	
	КоличествоУникальныхУпаковок = 7;
	
	ВыборкаХешСуммаУпаковки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаХешСуммаУпаковки.Следующий() Цикл
		СтрокаИсторическойУпаковки = ДанныеЗаполнения.СоставИсторическихУпаковок.Строки.Добавить();
		СтрокаИсторическойУпаковки.ХешСуммаУпаковки = ВыборкаХешСуммаУпаковки.ХешСуммаУпаковки;
		
		НоменклатураУпаковки = Новый Массив();
		
		Выборка = ВыборкаХешСуммаУпаковки.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(СтрокаИсторическойУпаковки.Строки.Добавить(), Выборка);
			НоменклатураУпаковки.Добавить(Выборка.Номенклатура);
		КонецЦикла;
		
		ДанныеЗаполнения.СписокИсторическихУпаковок.Добавить(ВыборкаХешСуммаУпаковки.ХешСуммаУпаковки,
			ИнтеграцияИС.ПредставлениеСоставаУпаковки(НоменклатураУпаковки));
		
		Если ДанныеЗаполнения.СоставИсторическихУпаковок.Строки.Количество() = КоличествоУникальныхУпаковок Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура РассчитатьИтогЭлементаСоставаУпаковки(ИтоговоеЗначение, ЭлементСостава)
	
	Если ИтоговоеЗначение = Null Тогда
		ИтоговоеЗначение = ЭлементСостава;
	ИначеЕсли ИтоговоеЗначение <> ЭлементСостава Тогда
		ИтоговоеЗначение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Функция НовыйШтрихкод(ТипШтрихкода, КлючНумератора, СерийныеНомераПоТипамШтрихкода)
	
	НовыйШтрихкод = "";
	
	Если ТипШтрихкода = Перечисления.ТипыШтрихкодов.SSCC Тогда
		СерийныйНомер = СерийныйНомерПоТипуШтрихкода(ТипШтрихкода, КлючНумератора, СерийныеНомераПоТипамШтрихкода);
		
		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("ЦифраРасширения",    Лев(КлючНумератора, 1));
		ПараметрыШтрихкода.Вставить("ПрефиксКомпанииGS1", Сред(КлючНумератора, 2));
		ПараметрыШтрихкода.Вставить("СерийныйНомерSSCC",  СерийныйНомер);
		
		НовыйШтрихкод = ШтрихкодыУпаковокКлиентСервер.ШтрихкодSSCC(ПараметрыШтрихкода);
	Иначе
		ТекстОшибки = НСтр("ru = 'Формирование штрихкодов типа ""%1"" не поддерживается.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, ТипШтрихкода);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат НовыйШтрихкод;
	
КонецФункции

Функция СерийныйНомерПоТипуШтрихкода(ТипШтрихкода, КлючНумератора, СерийныеНомераПоТипамШтрихкода)
	
	ТекущийСерийныйНомер = СерийныеНомераПоТипамШтрихкода[ТипШтрихкода];
	
	Если ТекущийСерийныйНомер <> Неопределено Тогда
	ИначеЕсли ТипШтрихкода = Перечисления.ТипыШтрихкодов.SSCC Тогда
		ЧастьШтрихкодаСоСкобками = "(00)" + КлючНумератора;
		ЧастьШтрихкодаБезСкобок  = "00" + КлючНумератора;
		
		ТекстЗапроса = "
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	&ВыражениеСерийныйНомерSSCC КАК СерийныйНомерSSCC
		|ИЗ
		|	Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
		|ГДЕ
		|	ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода ПОДОБНО &ЧастьШтрихкода
		|	И ШтрихкодыУпаковокТоваров.ТипШтрихкода = &ТипШтрихкода
		|УПОРЯДОЧИТЬ ПО
		|	СерийныйНомерSSCC УБЫВ
		|";
		
		Запрос = Новый Запрос();
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ВыражениеСерийныйНомерSSCC", "ПОДСТРОКА(ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода, 15, 7)");
		Запрос.УстановитьПараметр("ЧастьШтрихкода", ЧастьШтрихкодаСоСкобками + "%");
		Запрос.УстановитьПараметр("ТипШтрихкода",   ТипШтрихкода);
		
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ВыражениеСерийныйНомерSSCC", "ПОДСТРОКА(ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода, 13, 7)");
			Запрос.УстановитьПараметр("ЧастьШтрихкода", ЧастьШтрихкодаБезСкобок + "%");
			Результат = Запрос.Выполнить();
		КонецЕсли;

		Если Результат.Пустой() Тогда
			ТекущийСерийныйНомер = 0;
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ТекущийСерийныйНомер = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Выборка.СерийныйНомерSSCC);
		КонецЕсли;
	КонецЕсли;
	
	ТекущийСерийныйНомер = ТекущийСерийныйНомер + 1;
	
	СерийныеНомераПоТипамШтрихкода.Вставить(ТипШтрихкода, ТекущийСерийныйНомер);
	
	Возврат ТекущийСерийныйНомер;
	
КонецФункции

Функция НоваяОстаткиПродукции()
	
	ОстаткиПродукции = Новый ТаблицаЗначений();
	ОстаткиПродукции.Колонки.Добавить("НомерСтроки",                Новый ОписаниеТипов("Число"));
	ОстаткиПродукции.Колонки.Добавить("Номенклатура",               Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ОстаткиПродукции.Колонки.Добавить("Характеристика",             Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ОстаткиПродукции.Колонки.Добавить("Количество",                 Новый ОписаниеТипов("Число"));
	ОстаткиПродукции.Колонки.Добавить("Остаток",                    Новый ОписаниеТипов("Число"));
	ОстаткиПродукции.Колонки.Добавить("ЕстьСвободныйОстаток",       Новый ОписаниеТипов("Булево"));
	ОстаткиПродукции.Колонки.Добавить("КоличествоВУпаковках",       Новый ОписаниеТипов("Число"));
	ОстаткиПродукции.Колонки.Добавить("ХарактеристикиИспользуются", Новый ОписаниеТипов("Булево"));
	
	Возврат ОстаткиПродукции;
	
КонецФункции

Функция НовоеСоставИсторическихУпаковок()
	
	СоставИсторическихУпаковок = Новый ДеревоЗначений();
	СоставИсторическихУпаковок.Колонки.Добавить("ХешСуммаУпаковки", Новый ОписаниеТипов("Строка"));
	СоставИсторическихУпаковок.Колонки.Добавить("Номенклатура",     Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	СоставИсторическихУпаковок.Колонки.Добавить("Характеристика",   Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	СоставИсторическихУпаковок.Колонки.Добавить("Серия",            Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	СоставИсторическихУпаковок.Колонки.Добавить("Количество",       Новый ОписаниеТипов("Число"));
	
	Возврат СоставИсторическихУпаковок;
	
КонецФункции

Функция НоваяСоставУпаковки() Экспорт
	
	СоставУпаковки = Новый ТаблицаЗначений();
	СоставУпаковки.Колонки.Добавить("Номенклатура",   Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	СоставУпаковки.Колонки.Добавить("Характеристика", Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	СоставУпаковки.Колонки.Добавить("Серия",          Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	СоставУпаковки.Колонки.Добавить("Количество",     Новый ОписаниеТипов("Число"));
	
	Возврат СоставУпаковки;
	
КонецФункции

#КонецОбласти

#КонецЕсли