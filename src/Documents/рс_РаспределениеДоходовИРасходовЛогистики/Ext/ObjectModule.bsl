		 
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
//
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
//
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
												,ПараметрОбъектКопирования);
	// Rarus-spb 2013.01.22 {											
	СуммаДокумента = 0;
	// Rarus-spb 2013.01.22 }	
	
	// ++ БоровинскаяОА (СофтЛаб) 19.12.18 Начало (#3096)
	Комментарий = "";
	База.Очистить();
	// -- БоровинскаяОА (СофтЛаб) 19.12.18 Конец (#3096)
	
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()
											
// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
//
// Параметры:
//  СтруктураШапкиДокумента - Структура
//  СтруктураТаблиц         - Структура
//  Отказ            		- Булево
//  Заголовок 				- Строка
//
Процедура ПроверкаДанных(Отказ, Заголовок)
	
	Если ВидОперации = Перечисления.рс_ВидыОперацийРаспределениеДоходовИРасходовЛогистики.КомпенсацияЛогистическихЗатратЗаСчетВнутреннихДоходов Тогда
		Если База.Итог("Сумма") <> 0 Тогда
			//бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("Итоговая сумма по базе расчета должна раняться нулю!",,, Отказ);
			//СофтЛаб Начало 2018-12-08 3096
			//бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("Итоговая сумма по базе расчета должна раняться нулю!", Отказ, Заголовок);
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("Итоговая сумма по базе расчета должна раняться нулю!");
			//СофтЛаб Конец 2018-12-08 3096
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
    Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	рс_РаспределениеДоходовИРасходовЛогистики.Ссылка
	|ИЗ
	|	Документ.рс_РаспределениеДоходовИРасходовЛогистики КАК рс_РаспределениеДоходовИРасходовЛогистики
	|ГДЕ
	|	рс_РаспределениеДоходовИРасходовЛогистики.Ссылка <> &Ссылка
	|	И рс_РаспределениеДоходовИРасходовЛогистики.ВидОперации = &ВидОперации
	|	И рс_РаспределениеДоходовИРасходовЛогистики.Организация = &Организация
	|	И рс_РаспределениеДоходовИРасходовЛогистики.Период = &Период
	|	И рс_РаспределениеДоходовИРасходовЛогистики.Проведен = ИСТИНА";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидОперации", ВидОперации);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", Период);
	ТаблицаЗапрос = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЗапрос.Количество() > 0 Тогда
		//СофтЛаб Начало 2018-12-08 3096
		//бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("Уже есть проведенный документ с такими же организацией, видом операции и периодом!", Отказ, Заголовок);
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("Уже есть проведенный документ с такими же организацией, видом операции и периодом!");
		//СофтЛаб Конец 2018-12-08 3096
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПроверкаДанных()

Функция ПолучитьТаблицуРасчета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	рс_РаспределениеДоходовИРасходовЛогистикиБаза.Счет,
	|	рс_РаспределениеДоходовИРасходовЛогистикиБаза.Объект,
	|	рс_РаспределениеДоходовИРасходовЛогистикиБаза.ФункцияЦФО КАК Функция,
	|	рс_РаспределениеДоходовИРасходовЛогистикиБаза.Сумма
	|ИЗ
	|	Документ.рс_РаспределениеДоходовИРасходовЛогистики.База КАК рс_РаспределениеДоходовИРасходовЛогистикиБаза
	|ГДЕ
	|	рс_РаспределениеДоходовИРасходовЛогистикиБаза.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ТаблицаЗапрос = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗапрос;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура выполняет движения по регистрам.
//
Процедура ДвиженияПоРегистрам(Отказ, Заголовок)
	
	ДвиженияМСФО	= Движения.бит_Дополнительный_2;
	
	Если ВидОперации = Перечисления.рс_ВидыОперацийРаспределениеДоходовИРасходовЛогистики.КомпенсацияЛогистическихЗатратЗаСчетВнутреннихДоходов Тогда
		
		Для Каждого СтрокаБаза Из База Цикл
			
			Движение = ДвиженияМСФО.Добавить();
			Движение.Период 	 		= Дата;
			Движение.Организация 		= Организация;
			
			Движение.СчетДт 			= СтрокаБаза.Счет;
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Объект",  СтрокаБаза.Объект);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  СтрокаБаза.ФункцияЦФО);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  Период);
			
			//СофтЛаб Начало 2018-12-08 3096
			//Движение.СчетКт 			= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.СчетВспомогательный, Дата);
			Движение.СчетКт 			= СчетУчета;
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  Период);
			//СофтЛаб Конец 2018-12-08 3096
			
			Движение.СуммаМУ			= СтрокаБаза.Сумма;
			Движение.СуммаРегл			= СтрокаБаза.Сумма;			
			Движение.СуммаУпр			= СтрокаБаза.Сумма;	
			Движение.Содержание 		= "Компенсация логистических затрат за " + Формат(Период.Дата, "ДФ='ММММ гггг'");

			Движение.ВидДвиженияМСФО	= Перечисления.БИТ_ВидыДвиженияМСФО.КорректировкаЭУ;
			
		КонецЦикла;
		
		// BIT AMerkulov 03-08-2015 ++	
		
	ИначеЕсли  ВидОперации = Перечисления.рс_ВидыОперацийРаспределениеДоходовИРасходовЛогистики.ДоставкаТоваровВнутренняя Тогда
		
		Для Каждого СтрокаБаза Из База Цикл
			
			Движение = ДвиженияМСФО.Добавить();
			Движение.Период 	 		= Дата;
			Движение.Организация 		= Организация;
			
			//СофтЛаб Начало 2018-12-08 3096
			//Движение.СчетДт 			= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.СчетУчетаДоставкаТоваров, Дата);
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Объект",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ОбъектДляРаспределенияДоставкаТоваров, Дата));
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ФункцияДляРаспределенияДоставкаТоваров, Дата)); 
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  Период);
			Движение.СчетДт 			= СчетУчета;
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Объект",  Субконто1);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  Субконто2); 
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  Период);
			//СофтЛаб Конец 2018-12-08 3096
			
			Движение.СчетКт 			= СтрокаБаза.Счет;
			//СофтЛаб Начало 2018-12-08 3096
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Объект",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ОбъектДляРаспределенияДоставкаТоваров, Дата));
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Функции",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ФункцияДляРаспределенияДоставкаТоваров, Дата)); 
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Периоды",  Период);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Объект",  Субконто1);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Функции",  Субконто2); 
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Периоды",  Период);
			//СофтЛаб Конец 2018-12-08 3096
			
			Движение.СуммаМУ			= СтрокаБаза.Сумма;			
			Движение.СуммаРегл			= СтрокаБаза.Сумма;			
			Движение.СуммаУпр			= СтрокаБаза.Сумма;			
			Движение.Содержание 		= "Распределение внутренней складской обработки за " + Формат(Период.Дата, "ДФ='ММММ гггг'");
			
			Движение.ВидДвиженияМСФО	= Перечисления.БИТ_ВидыДвиженияМСФО.КорректировкаЭУ;
			
		КонецЦикла;
		
		
		// BIT AMerkulov 03-08-2015--
		
	Иначе
		
		Для Каждого СтрокаБаза Из База Цикл
			
			Движение = ДвиженияМСФО.Добавить();
			Движение.Период 	 		= Дата;
			Движение.Организация 		= Организация;
			                                                 
			//СофтЛаб Начало 2018-12-08 3096
			//Движение.СчетДт 			= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.СчетУчетаОбработкаТоваров, Дата);
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Объект",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ОбъектДляРаспределенияОбработкаТоваров, Дата));
			////рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  СтрокаБаза.ФункцияЦФО);    //ОК Аверьянова 12032014
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ФункцияДляРаспределенияОбработкаТоваров, Дата)); //ОК Аверьянова 12032014
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  Период);
			Движение.СчетДт 			= СчетУчета;
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Объект",  Субконто1);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  Субконто2); 
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  Период);
			//СофтЛаб Конец 2018-12-08 3096
			
			Движение.СчетКт 			= СтрокаБаза.Счет;
			//СофтЛаб Начало 2018-12-08 3096
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Объект",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ОбъектДляРаспределенияОбработкаТоваров, Дата));
			////рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Функции",  СтрокаБаза.ФункцияЦФО);    //ОК Аверьянова 12032014
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Функции",  рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ФункцияДляРаспределенияОбработкаТоваров, Дата)); //ОК Аверьянова 12032014
			//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Периоды",  Период);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Объект",  Субконто1);
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Функции",  Субконто2); 
			рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Периоды",  Период);
			//СофтЛаб Конец 2018-12-08 3096
			
			Движение.СуммаМУ			= СтрокаБаза.Сумма;			
			Движение.СуммаРегл			= СтрокаБаза.Сумма;			
			Движение.СуммаУпр			= СтрокаБаза.Сумма;			
			Движение.Содержание 		= "Распределение внутренней складской обработки за " + Формат(Период.Дата, "ДФ='ММММ гггг'");

			Движение.ВидДвиженияМСФО	= Перечисления.БИТ_ВидыДвиженияМСФО.КорректировкаЭУ;
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПриКопировании"
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
	КонецЕсли;
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
		
	// Проверка данных
	ПроверкаДанных(Отказ, Заголовок);
	
	// Проведение
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Отказ, Заголовок);
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	ПечатнаяФорма = Документы.рс_РаспределениеДоходовИРасходовЛогистики.СформироватьПечатнуюФормуПротоколРасчета("", МассивСсылок);
	ХранилищеПечатнойФормы = Новый ХранилищеЗначения(ПечатнаяФорма, Новый СжатиеДанных(9));
	
	Движение = Движения.рс_ПротоколыРасчета.Добавить();
	Движение.Документ		 = Ссылка;
	Движение.ПротоколРасчета = ХранилищеПечатнойФормы;
	
КонецПроцедуры // ОбработкаПроведения()

// Rarus-spb byse 2012.12.27 {
Процедура РассчитатьСуммуДокумента () Экспорт
	СуммаДокумента = База.Итог("Сумма");
КонецПроцедуры	                        
// Rarus-spb byse 2012.12.27 {
