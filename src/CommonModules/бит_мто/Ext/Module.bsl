
#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПодписок

// Процедура-обработчик подписки бит_мто_ПриЗаписиДокументыОткажениеЗакупок на событие ПриЗаписи.
// 
Процедура бит_мто_ОтражениеФактаЗакупкиПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
		
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	
	КонецЕсли; 			
	
	Если Источник.ДополнительныеСвойства.Свойство("бит_ЗаполнениеНаОснованииПлана") Тогда
		Возврат;
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОтражениеФакта = НайтиДокументОтражения(Источник.Ссылка);
	
	Если ЗначениеЗаполнено(ОтражениеФакта) Тогда
		
		ОтражениеФактаОбъект = ОтражениеФакта.ПолучитьОбъект();
		
		Если Источник.ПометкаУдаления <> ОтражениеФактаОбъект.ПометкаУдаления Тогда
			
			// Синхронизация пометки удаления							
			ОтражениеФактаОбъект.УстановитьПометкуУдаления(Источник.ПометкаУдаления);
			
		КонецЕсли; 
		
		Если ОтражениеФактаОбъект.НеСинхронизировать = Ложь Тогда
			
			ОтражениеФактаОбъект.ЗаполнитьПоОснованию(Источник);
			ОтражениеФактаОбъект.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // бит_мто_ОтражениеФактаЗакупкиПриЗаписи()

// Процедура-обработчик подписки бит_мто_ОбработкаПроведенияЗакупки на событие ОбработкаПроведения.
// 
Процедура бит_мто_ОбработкаПроведенияЗакупкиОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
		
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	
	КонецЕсли; 			
	
	ОтражениеФакта = НайтиДокументОтражения(Источник.Ссылка);
	
	Если ЗначениеЗаполнено(ОтражениеФакта) Тогда
	
		Документы.бит_мто_ОтражениеФактаЗакупки.ДвиженияПоРегистрамОтражениеФактаЗакупки(Источник, Отказ, Истина);
		
	// Когда нет документа отражение, проводим по регистру бит_мто_НезапланированныеЗакупки с данными из ТЧ документа
	// "Поступление товаров и услуг".
	Иначе	
		
		ПровестиДокументПоРегиструНезапланированныеЗакупки(Источник);
		
	КонецЕсли;	
		
КонецПроцедуры // бит_мто_ОбработкаПроведенияЗакупкиОбработкаПроведения()

// Процедура производит необходимые действия
// при отмене проведения документа Поступление товаров и услуг.
// 
// Параметры:
//  Источник - ДокументОбъект
//  Отказ - Булево
// 
Процедура бит_мто_ОбработкаОтменыПроведенияЗакупки(Источник, Отказ) Экспорт 

	Если Отказ Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	ОтражениеДок = НайтиДокументОтражения(Источник.Ссылка);
	
	ТаблицаОтражение = ОтражениеДок.ФактическиеДанные.Выгрузить();
	
	
	ТаблицаЗаявокНаПотр = ТаблицаОтражение.Скопировать();
	ТаблицаЗаявокНаПотр.Свернуть("ЗаявкаНаПотребность");
	
	Для каждого СтрокаЗаявка Из ТаблицаЗаявокНаПотр Цикл
	
		Если ЗначениеЗаполнено(СтрокаЗаявка.ЗаявкаНаПотребность) Тогда
		
			ЗаявкаНаПотр = СтрокаЗаявка.ЗаявкаНаПотребность.ПолучитьОбъект();
			ЗаявкаНаПотр.УстановитьСтатус();
			
		КонецЕсли; 
	
	КонецЦикла; 
	
	ТаблицаЗаявокНаЗакупку = ТаблицаОтражение.Скопировать();
	ТаблицаЗаявокНаЗакупку.Свернуть("ЗаявкаНаЗакупку");
	
	Для каждого СтрокаЗаявка Из ТаблицаЗаявокНаЗакупку Цикл
	
		Если ЗначениеЗаполнено(СтрокаЗаявка.ЗаявкаНаЗакупку) Тогда
		
			ЗаявкаНаЗакупку = СтрокаЗаявка.ЗаявкаНаЗакупку.ПолучитьОбъект();
			ЗаявкаНаЗакупку.УстановитьСтатус();
		
		КонецЕсли; 
	
	КонецЦикла; 
	
КонецПроцедуры // ПриОтменеДвиженийПоРегистрам()

#КонецОбласти 	

#Область ПроверкиВозможностиСозданияДокументовМТО

// Функция проверяет возможность создания
// документа Закупки/ПередачаВОбеспечение на основании Заявки на потребность.
// 
// Параметры:
//  ДокументПотребность - ДокументСсылка.бит_мто_ЗаявкаНаПотребность.
// 
Функция ПроверитьВозможностьСозданияДокумента(ДокументПотребность) Экспорт 

	СтрВозврата = Новый Структура("Возможно, ТекстСообщения", Ложь, ""); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_СтатусыОбъектов.Статус,
	               |	бит_СтатусыОбъектов.Объект КАК Заявка
	               |ИЗ
	               |	РегистрСведений.бит_СтатусыОбъектов КАК бит_СтатусыОбъектов
	               |ГДЕ
	               |	бит_СтатусыОбъектов.ВидСтатуса = ЗНАЧЕНИЕ(Перечисление.бит_ВидыСтатусовОбъектов.Статус)
	               |	И бит_СтатусыОбъектов.Объект = &Документ";
	
	Запрос.УстановитьПараметр("Документ", ДокументПотребность);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Утверждена
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_ЧастичноИсполнена
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Выдача
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Закупка Тогда 
		
			ТаблицаОстатков = Документы.бит_мто_ЗаявкаНаПотребность.ПолучитьОстаткиНоменклатурыТабЧастиТовары(ДокументПотребность);

			Для каждого СтрокаОстаков Из ТаблицаОстатков Цикл
			
				Если СтрокаОстаков.СуммаОстаток <> 0 Тогда
					
					СтрВозврата.Вставить("Возможно", Истина);
					Возврат СтрВозврата;
				
				КонецЕсли; 
			
			КонецЦикла; 
			
		ИначеЕсли Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Исполнена Тогда 
			
			СтрВозврата.Вставить("ТекстСообщения", НСтр("ru = 'Создание на основании в статусе ""Исполнена"" не выполняется!'"));
			Возврат СтрВозврата;
			
		ИначеЕсли Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Закрыта Тогда 
			
			СтрВозврата.Вставить("ТекстСообщения", НСтр("ru = 'Создание на основании в статусе ""Закрыта"" не выполняется!'"));
			Возврат СтрВозврата;
			
		Иначе	
			
			СтрВозврата.Вставить("ТекстСообщения", НСтр("ru = 'Создание на основании разрешено только после утверждения заявки!'"));
			Возврат СтрВозврата;
			
		КонецЕсли; 
	
	КонецЦикла;
	
	Возврат СтрВозврата;
	
КонецФункции // ПроверитьВозможностьСозданияДокумента()

// Функция проверяет возможность выдачи ТМЦ.
// 
Функция ПроверитьВозможностьСозданияДокументаВыдачи(Документ) Экспорт 

	СтрВозврата = Новый Структура("Возможно, ТекстСообщения", Ложь, ""); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_СтатусыОбъектов.Статус,
	               |	бит_СтатусыОбъектов.Объект КАК Заявка
	               |ИЗ
	               |	РегистрСведений.бит_СтатусыОбъектов КАК бит_СтатусыОбъектов
	               |ГДЕ
	               |	бит_СтатусыОбъектов.ВидСтатуса = ЗНАЧЕНИЕ(Перечисление.бит_ВидыСтатусовОбъектов.Статус)
	               |	И бит_СтатусыОбъектов.Объект = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Утверждена
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_ЧастичноИсполнена
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Исполнена
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Выдача
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Закупка Тогда 
		
			Успех = бит_мто.ПроверитьВозможностьСозданияВыдачиТМЦ(Документ);
			
			СтрВозврата.Вставить("Возможно", Успех); 
			
			Если НЕ Успех Тогда
			
				СтрВозврата.Вставить("ТекстСообщения", НСтр("ru = 'Отсутствует номенклатура к выдаче!'"));
				Возврат СтрВозврата;
			
			КонецЕсли; 
			
		ИначеЕсли Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаПотребность_Закрыта Тогда 
			
			СтрВозврата.Вставить("ТекстСообщения", НСтр("ru = 'Создание на основании в статусе ""Закрыта"" не выполняется!'"));
			Возврат СтрВозврата;
			
		Иначе	
			
			СтрВозврата.Вставить("ТекстСообщения", НСтр("ru = 'Создание на основании разрешено только после утверждения заявки!'"));
			Возврат СтрВозврата;
			
		КонецЕсли; 
	
	КонецЦикла;
	
	Возврат СтрВозврата;

КонецФункции // ПроверитьВозможностьСозданияДокументаВыдачи()

// Функция проверяет остатки номенклатуры в регистре бит_мто_НоменклатураКВыдачеПоЗаявкамНаПотребность.
// 
// Параметры:
//  Документ - ДокументСсылка.бит_мто_ЗаявкаНаПотребность.
// 
Функция ПроверитьВозможностьСозданияВыдачиТМЦ(Документ) Экспорт 

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаявкаНаПотребность"	, Документ);
	Запрос.УстановитьПараметр("Организация"			, Документ.Организация);
	Запрос.УстановитьПараметр("ЦФО"					, Документ.ЦФО);
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураКВыдаче.Номенклатура,
	               |	НоменклатураКВыдаче.Потребность,
	               |	ЕСТЬNULL(НоменклатураКВыдаче.КоличествоОстаток, 0) КАК Количество
	               |ИЗ
	               |	РегистрНакопления.бит_мто_НоменклатураКВыдачеПоЗаявкамНаПотребность.Остатки(
	               |			,
	               |			ЗаявкаНаПотребность = &ЗаявкаНаПотребность
	               |				И Организация = &Организация
	               |				И ЦФО = &ЦФО) КАК НоменклатураКВыдаче";
	
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
	
		Возврат Ложь;
	
	КонецЕсли; 
	
	Возврат Истина;
	
КонецФункции // ПроверитьВозможностьСозданияВыдачиТМЦ()

#КонецОбласти 	

// Функция выполняет поиск документа ОтражениеФактаЗакупки по документу основанию.
// 
// Параметры:
//  ДокументОснование - ДокументСсылка.
// 
// Возвращаемое значение:
//  ДокументОтражение - ДокументСсылка.бит_ОтражениеФактаЗакупки.
// 
Функция НайтиДокументОтражения(ДокументОснование) Экспорт

	Режим = ПривилегированныйРежим();
	
	Если Не Режим Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ДокументОтражение = Документы.бит_мто_ОтражениеФактаЗакупки.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	бит_мто_ОтражениеФактаЗакупки.Ссылка
	               |ИЗ
	               |	Документ.бит_мто_ОтражениеФактаЗакупки КАК бит_мто_ОтражениеФактаЗакупки
	               |ГДЕ
	               |	бит_мто_ОтражениеФактаЗакупки.ДокументОснование = &ДокументОснование";
				   
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		ДокументОтражение = Выборка.Ссылка;
	
	КонецЕсли; 

	Если Не Режим Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ДокументОтражение;
	
КонецФункции // НайтиДокументОтражения()

// Функция проверяет вид операции документа.
// 
// Параметры:
//  Документ - ДокументСсылка.бит_мто_ЗаявкаНаПотребность.
// 
Функция ЭтоУслуга(Документ) Экспорт 

	Если Документ.ВидОперации = Перечисления.бит_мто_ВидыОперацийЗаявокНаПотребность.Услуги Тогда
	
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли; 

КонецФункции // ЭтоУслуга()

// Процедура формирует заголовки полей схемы компоновки данных связанных с дополнительными
//	измерениями регистра в соответствии с указанными настройками доп.измерений.
//
// Параметры:
//	СхемаКомпоновкиДанных - СхемаКомпоновкиДанных
//	ИмяНабораДанных - Строка - набор данных переданной схемы компоновки данных,
//					в котором необходимо сформировать заголовки полей связанных с дополнительными измерениями
//	НастройкиИзмерений - Соответствие - настройки используемых дополнительных измерений
//	ДопИзмерения - Структура - содержит дополнительные измерения регистра накопления "бит_ОборотыПоБюджетам".
//
Процедура СформироватьЗаголовкиАналитикТЧФактическиеДанные(СхемаКомпоновкиДанных, ИмяНабораДанных, НастройкиИзмерений=Неопределено, ДопИзмерения=Неопределено) Экспорт

	Если ДопИзмерения = Неопределено Тогда
		
		ДопИзмерения = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("Дополнительные","Синоним");
		
	КонецЕсли;
	
	Если НастройкиИзмерений = Неопределено Тогда
		
		НастройкиИзмерений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");
		
	КонецЕсли;
	
	Поля = СхемаКомпоновкиДанных.НаборыДанных[ИмяНабораДанных].Поля;
	
	Для Каждого ТекущаяНастройка Из ДопИзмерения Цикл
		
		ИскомоеПоле = "ФактическиеДанные." + ТекущаяНастройка.Ключ;
		
		НайденноеПоле = Поля.Найти(ИскомоеПоле);
		
		Если НайденноеПоле = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если НастройкиИзмерений[ТекущаяНастройка.Ключ] = Неопределено Тогда
			НайденноеПоле.Заголовок 	= "Не используется";
		Иначе
			НайденноеПоле.Заголовок 	= НастройкиИзмерений[ТекущаяНастройка.Ключ].Синоним;
			//НайденноеПоле.Поле = "ФактическиеДанные." + НастройкиИзмерений[ТекущаяНастройка.Ключ].Синоним;
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(НастройкиИзмерений[ТекущаяНастройка.Ключ].ЗначениеПоУмолчанию));
			
			НайденноеПоле.ТипЗначения 	= Новый ОписаниеТипов(МассивТипов);
		КонецЕсли;
		
	КонецЦикла;
	

КонецПроцедуры // СформироватьЗаголовкиАналитикТЧФактическиеДанные()

// Процедура получает сведения о номенклатуре и заполняет табличную часть.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура.
//  ДанныеОбъекта - Объект - объект.
// 
// Возвращаемое значение:
//  СведенияОНоменклатуре - Соответствие.
//
Процедура ЗаполнитьДанныеПоНоменклатуре(СтрокаТабличнойЧасти, Форма) Экспорт 

	Объект = Форма.Объект;
	
	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, Объект, Ложь);

	Если СведенияОНоменклатуре <> Неопределено Тогда
	
		СтрокаТабличнойЧасти.ЕдиницаИзмерения	= СведенияОНоменклатуре.ЕдиницаИзмерения;
		СтрокаТабличнойЧасти.Коэффициент		= СведенияОНоменклатуре.Коэффициент;
		СтрокаТабличнойЧасти.Цена				= СведенияОНоменклатуре.Цена;
		СтрокаТабличнойЧасти.СтавкаНДС			= СведенияОНоменклатуре.СтавкаНДС;
	
	КонецЕсли; 
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проводит док Поступление товаров и услуг без документа отражение. 
// 
Процедура ПровестиДокументПоРегиструНезапланированныеЗакупки(Основание)

	Если Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Товары
		ИЛИ Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги
		ИЛИ Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Оборудование
		ИЛИ Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия Тогда
		
		ТабличнаяЧастьОснование = Документы.бит_мто_ОтражениеФактаЗакупки.ПодготовитьТабличнуюЧастьПоступленияТоваровУслуг(Основание);
	
		Документы.бит_мто_ОтражениеФактаЗакупки.СформироватьДвиженияНезапланированныеЗакупки(Основание, ТабличнаяЧастьОснование, Истина, Ложь);

	КонецЕсли;
	
КонецПроцедуры // ПровестиДокументПоРегиструНезапланированныеЗакупки()

#КонецОбласти
