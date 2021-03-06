
////бит_MZyubin Процедура выполняет инициализацию текста построителя отчета
////
//Процедура ИнициализацияТекстаЗапроса(Подбор07_0804=Ложь) Экспорт
//	
//	ТекстЗапроса = "";
//	
//	// сформируем тексты запроса для различных режимов подбора
//	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуОС Тогда
//		
//		// BIT Avseenkov 15052014 /Доработка функцонала по уастку основных средств {
//		Если Подбор07_0804 Тогда 
//			ТекстЗапроса = СформироватьТекстЗапросаОС07_0804();
//		Иначе 
//		//}
//			ТекстЗапроса = СформироватьТекстЗапросаПринятиеКУчетуОС();
//		КонецЕсли;
//	
//	ИначеЕсли Режим = Перечисления.бит_му_РежимыПодбораВНА.МодернизацияОС Тогда
//		// BIT Avseenkov 15052014 /Доработка функцонала по уастку основных средств {
//		Если Подбор07_0804 Тогда 
//			ТекстЗапроса = СформироватьТекстЗапросаОС07_0804();
//		Иначе 
//		//}

//		ТекстЗапроса = СформироватьТекстЗапросаМодернизацияОС();
//		КонецЕсли;
//	ИначеЕсли Режим = Перечисления.бит_му_РежимыПодбораВНА.бит_КомплектацияОС Тогда
//		
//		ТекстЗапроса = СформироватьТекстЗапросаКомплектацияОС();		
//		
//	КонецЕсли; 	
//	
//	Если Не ПустаяСтрока(ТекстЗапроса) Тогда
//		ПостроительОтчета.Текст = ТекстЗапроса;
//	КонецЕсли;
//	
//	#Если Клиент Тогда
//		
//		СтруктураСоответствия = Новый Структура;
//		СтруктураСоответствия.Вставить("ИнвентарныйНомер"          ,"Инвентарный номер");
//		СтруктураСоответствия.Вставить("ВидКласса"                 ,"Вид класса");
//		СтруктураСоответствия.Вставить("НачислятьАмортизацию"      ,"Начислять амортизацию");
//		СтруктураСоответствия.Вставить("МетодНачисленияАмортизации","Метод начисления амортизации");
//		СтруктураСоответствия.Вставить("МодельУчета"               ,"Модель учета");		
//		
//		УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураСоответствия,ПостроительОтчета);
//		
//	#КонецЕсли
//	
//КонецПроцедуры // ИнициализацияТекстаЗапроса()

////бит_MZyubin Процедура заполняет табличную часть ПереченьОбъектов
////
//Процедура ОбновитьПереченьОбъектов()   Экспорт

//	ВалютаМУ = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация);
//	
//	Если НЕ ЗначениеЗаполнено(ВалютаМУ) Тогда
//		Возврат;
//	КонецЕсли; 
//	
//	// заполним параметры построителя
//	ПостроительОтчета.Параметры.Вставить("ПустаяДата"   ,Дата('00010101'));
//	ПостроительОтчета.Параметры.Вставить("НачалоПериода",ДатаНачала);
//	ПостроительОтчета.Параметры.Вставить("КонецПериода" ,КонецДня(ДатаОкончания));
//	
//	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуОС
//		Или Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуНМА Тогда
//		
//		СтрКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаМУ,ДатаОкончания);
//		
//		ПостроительОтчета.Параметры.Вставить("КурсМУ"     		 , ?(СтрКурса.Курс	    = 0, 1, СтрКурса.Курс));
//		ПостроительОтчета.Параметры.Вставить("КратностьМУ"		 , ?(СтрКурса.Кратность = 0, 1, СтрКурса.Кратность));
//		ПостроительОтчета.Параметры.Вставить("СчетВНА"    		 , ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы);
//		
//		Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуОС Тогда
//			ПостроительОтчета.Параметры.Вставить("СчетОС"     		 , ПланыСчетов.Хозрасчетный.ОСвОрганизации);
//			ПостроительОтчета.Параметры.Вставить("СостояниеПринятоБУ", Перечисления.СостоянияОС.ПринятоКУчету);
//		Иначе
//			ПостроительОтчета.Параметры.Вставить("СчетНМА"     		 , ПланыСчетов.Хозрасчетный.НематериальныеАктивыОрганизации);
//			ПостроительОтчета.Параметры.Вставить("СостояниеПринятоБУ", Перечисления.ВидыСостоянийНМА.ПринятКУчету);
//		КонецЕсли;
//		
//	КонецЕсли; 
//	
//	ПостроительОтчета.Выполнить();
//	
//	Результат = ПостроительОтчета.Результат;
//	
//	// заполнение табличной части
//	ПереченьОбъектов.Очистить();
//	
//	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеОС
//		Или Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеНМА Тогда
//		
//		ВыборкаПоВНА = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
//		
//		Пока ВыборкаПоВНА.Следующий() Цикл
//			
//			ВыборкаДокументов = ВыборкаПоВНА.Выбрать();
//			
//			Если ВыборкаДокументов.Следующий() Тогда
//				НоваяСтрока = ПереченьОбъектов.Добавить();
//				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДокументов);
//			КонецЕсли;
//			
//		КонецЦикла;
//		
//	Иначе
//		
//		Если НЕ Результат.Пустой() Тогда
//			ПереченьОбъектов.Загрузить(Результат.Выгрузить());
//		КонецЕсли; 
//		
//	КонецЕсли;


//КонецПроцедуры //ОбновитьПереченьОбъектов()

//////////////////////////////////////////////////////////////////////////////////
//// ФУНКЦИИ ПО ФОРМИРОВАНИЮ ТЕКСТА ЗАПРОСА ДЛЯ ПОДБОРА


////БИТ Тртилек 08.08.2012 Функция формирует текст запроса в режиме подбора МодернизацияОС
////
//// Возвращаемое значение:
////   ТекстЗапроса   – Строка
////
//Функция СформироватьТекстЗапросаМодернизацияОС()			   

//	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	               |	ИСТИНА КАК Выполнять,
//	               |	ХозрасчетныйОбороты.Счет,
//	               |	ХозрасчетныйОбороты.Субконто1,
//	               |	ХозрасчетныйОбороты.Субконто2,
//	               |	ХозрасчетныйОбороты.Субконто3,
//	               |	ХозрасчетныйОбороты.КорСчет,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОСвОрганизации), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МЦвОрганизации))
//	               |			ТОГДА ВЫБОР
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто1 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто1
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто2 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто2
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто3 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто3
//	               |					ИНАЧЕ 0
//	               |				КОНЕЦ
//	               |	КОНЕЦ КАК ОсновноеСредство,
//	               |	ХозрасчетныйОбороты.Организация,
//	               |	ХозрасчетныйОбороты.Валюта,
//	               |	ХозрасчетныйОбороты.ВалютаКор,
//	               |	ХозрасчетныйОбороты.Подразделение,
//	               |	ХозрасчетныйОбороты.ПодразделениеКор,
//	               |	ХозрасчетныйОбороты.Регистратор,
//	               |	ХозрасчетныйОбороты.Регистратор.Дата,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОСвОрганизации), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МЦвОрганизации))
//	               |			ТОГДА -ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотДт, 0) + ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, 0)
//	               |		ИНАЧЕ ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотДт, 0) - ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, 0)
//	               |	КОНЕЦ КАК Сумма
//	               |ПОМЕСТИТЬ ВТХозрасчетныеОбороты
//	               |ИЗ
//	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&Счет0801, &Счет0802, &Счет0803), , {(Организация)}, , ) КАК ХозрасчетныйОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//	               |		ПО ХозрасчетныйОбороты.Регистратор = бит_му_КомплектацияОС.ДокументРСБУ
//	               |			И (ВЫБОР
//	               |				КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (&Счет01, &Счет03)
//	               |					ТОГДА ХозрасчетныйОбороты.КорСубконто1 = бит_му_КомплектацияОС.АналитикаРСБУ
//	               |				ИНАЧЕ ХозрасчетныйОбороты.Субконто1 = бит_му_КомплектацияОС.АналитикаРСБУ
//	               |			КОНЕЦ)
//	               |ГДЕ
//	               |	бит_му_КомплектацияОС.ДокументРСБУ ЕСТЬ NULL 
//	               |{ГДЕ
//	               |	(ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто1 КАК Справочник.ОбъектыСтроительства)).* КАК ОбъектСтроительства,
//	               |	ХозрасчетныйОбороты.Регистратор.*}
//	               |
//	               |ОБЪЕДИНИТЬ ВСЕ
//	               |
//	               |ВЫБРАТЬ
//	               |	ИСТИНА,
//	               |	ХозрасчетныйОбороты.Счет,
//	               |	ХозрасчетныйОбороты.Субконто1,
//	               |	ХозрасчетныйОбороты.Субконто2,
//	               |	ХозрасчетныйОбороты.Субконто3,
//	               |	ХозрасчетныйОбороты.КорСчет,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.Субконто1 ССЫЛКА Справочник.ОсновныеСредства
//	               |			ТОГДА ХозрасчетныйОбороты.Субконто1
//	               |		КОГДА ХозрасчетныйОбороты.Субконто2 ССЫЛКА Справочник.ОсновныеСредства
//	               |			ТОГДА ХозрасчетныйОбороты.Субконто2
//	               |		КОГДА ХозрасчетныйОбороты.Субконто3 ССЫЛКА Справочник.ОсновныеСредства
//	               |			ТОГДА ХозрасчетныйОбороты.Субконто3
//	               |		ИНАЧЕ 0
//	               |	КОНЕЦ,
//	               |	ХозрасчетныйОбороты.Организация,
//	               |	ХозрасчетныйОбороты.Валюта,
//	               |	ХозрасчетныйОбороты.ВалютаКор,
//	               |	ХозрасчетныйОбороты.Подразделение,
//	               |	ХозрасчетныйОбороты.ПодразделениеКор,
//	               |	ХозрасчетныйОбороты.Регистратор,
//	               |	ХозрасчетныйОбороты.Регистратор.Дата,
//	               |	ХозрасчетныйОбороты.СуммаОборотДт
//	               |ИЗ
//	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&Счет01, &Счет03), , {(Организация)}, , ) КАК ХозрасчетныйОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//	               |		ПО ХозрасчетныйОбороты.Регистратор = бит_му_КомплектацияОС.ДокументРСБУ
//	               |			И ХозрасчетныйОбороты.Субконто1 = бит_му_КомплектацияОС.АналитикаРСБУ
//	               |ГДЕ
//	               |	бит_му_КомплектацияОС.ДокументРСБУ ЕСТЬ NULL 
//	               |	И ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков
//	               |	И ХозрасчетныйОбороты.Регистратор.РазделУчета = &РазделУчета
//	               |{ГДЕ
//	               |	(ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто1.Объект КАК Справочник.ОбъектыСтроительства)).* КАК ОбъектСтроительства,
//	               |	ХозрасчетныйОбороты.Регистратор.*}
//	               |;
//	               |
//	               |////////////////////////////////////////////////////////////////////////////////
//	               |ВЫБРАТЬ
//	               |	ВТХозрасчетныеОбороты.ОсновноеСредство КАК ВНА,
//	               |	ВТХозрасчетныеОбороты.Организация,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
//	               |	ВТХозрасчетныеОбороты.Регистратор КАК ДокументБУ,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость,
//	               |	ВТХозрасчетныеОбороты.Выполнять,
//	               |	СостоянияОСОрганизацийСрезПоследних.ДатаСостояния КАК ДатаПринятияКУчету,
//	               |	ВТХозрасчетныеОбороты.РегистраторДата КАК РегистраторДата,
//	               |	ТИПЗНАЧЕНИЯ(ВТХозрасчетныеОбороты.Регистратор) КАК ТипРегистратора,
//	               |	СУММА(ВТХозрасчетныеОбороты.Сумма) КАК Сумма,
//	               |	ВТХозрасчетныеОбороты.Счет
//	               |ИЗ
//	               |	ВТХозрасчетныеОбороты КАК ВТХозрасчетныеОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация)}) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
//	               |			И ВТХозрасчетныеОбороты.Организация = МестонахождениеОСБухгалтерскийУчетСрезПоследних.Организация
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, ) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций.СрезПоследних КАК СостоянияОСОрганизацийСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = СостоянияОСОрганизацийСрезПоследних.ОсновноеСредство
//	               |			И (СостоянияОСОрганизацийСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету))
//	               |{ГДЕ
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ.*,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение.*}
//	               |
//	               |СГРУППИРОВАТЬ ПО
//	               |	ВТХозрасчетныеОбороты.ОсновноеСредство,
//	               |	ВТХозрасчетныеОбороты.Организация,
//	               |	ВТХозрасчетныеОбороты.Регистратор,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость,
//	               |	ВТХозрасчетныеОбороты.Выполнять,
//	               |	СостоянияОСОрганизацийСрезПоследних.ДатаСостояния,
//	               |	ВТХозрасчетныеОбороты.РегистраторДата,
//	               |	ВТХозрасчетныеОбороты.Счет
//	               |
//	               |УПОРЯДОЧИТЬ ПО
//	               |	РегистраторДата,
//	               |	ТипРегистратора,
//	               |	ВТХозрасчетныеОбороты.Регистратор.Номер";

//	Возврат ТекстЗапроса; 
//		
//КонецФункции // СформироватьТекстЗапросаМодернизацияОС()

////БИТ Тртилек 08.08.2012 Функция формирует текст запроса для режима ПринятиеКУчетуОС
////
//// Возвращаемое значение:
////   ТекстЗапроса   – Строка
////
//Функция СформироватьТекстЗапросаПринятиеКУчетуОС()

//	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	               |	ИСТИНА КАК Выполнять,
//	               |	ХозрасчетныйОбороты.Счет,
//	               |	ХозрасчетныйОбороты.Субконто1,
//	               |	ХозрасчетныйОбороты.Субконто2,
//	               |	ХозрасчетныйОбороты.Субконто3,
//	               |	ХозрасчетныйОбороты.КорСчет,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОСвОрганизации), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МЦвОрганизации))
//	               |			ТОГДА ВЫБОР
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто1 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто1
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто2 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто2
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто3 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто3
//	               |					ИНАЧЕ 0
//	               |				КОНЕЦ
//	               |	КОНЕЦ КАК ОсновноеСредство,
//	               |	ХозрасчетныйОбороты.Организация,
//	               |	ХозрасчетныйОбороты.Валюта,
//	               |	ХозрасчетныйОбороты.ВалютаКор,
//	               |	ХозрасчетныйОбороты.Подразделение,
//	               |	ХозрасчетныйОбороты.ПодразделениеКор,
//	               |	ХозрасчетныйОбороты.Регистратор,
//	               |	ХозрасчетныйОбороты.Регистратор.Дата,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОСвОрганизации), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МЦвОрганизации))
//	               |			ТОГДА -ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотДт, 0) + ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, 0)
//	               |		ИНАЧЕ ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотДт, 0) - ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, 0)
//	               |	КОНЕЦ КАК Сумма
//	               |ПОМЕСТИТЬ ВТХозрасчетныеОбороты
//	               |ИЗ
//	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&Счет0801, &Счет0802, &Счет0803), , {(Организация)}, , ) КАК ХозрасчетныйОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//	               |		ПО ХозрасчетныйОбороты.Регистратор = бит_му_КомплектацияОС.ДокументРСБУ
//	               |			И (ВЫБОР
//	               |				КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (&Счет01, &Счет03)
//	               |					ТОГДА ХозрасчетныйОбороты.КорСубконто1 = бит_му_КомплектацияОС.АналитикаРСБУ
//	               |				ИНАЧЕ ХозрасчетныйОбороты.Субконто1 = бит_му_КомплектацияОС.АналитикаРСБУ
//	               |			КОНЕЦ)
//	               |ГДЕ
//	               |	бит_му_КомплектацияОС.ДокументРСБУ ЕСТЬ NULL 
//	               |{ГДЕ
//	               |	(ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто1 КАК Справочник.ОбъектыСтроительства)).* КАК ОбъектСтроительства,
//	               |	ХозрасчетныйОбороты.Регистратор.*}
//	               |
//	               |ОБЪЕДИНИТЬ ВСЕ
//	               |
//	               |ВЫБРАТЬ
//	               |	ИСТИНА,
//	               |	ХозрасчетныйОбороты.Счет,
//	               |	ХозрасчетныйОбороты.Субконто1,
//	               |	ХозрасчетныйОбороты.Субконто2,
//	               |	ХозрасчетныйОбороты.Субконто3,
//	               |	ХозрасчетныйОбороты.КорСчет,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.Субконто1 ССЫЛКА Справочник.ОсновныеСредства
//	               |			ТОГДА ХозрасчетныйОбороты.Субконто1
//	               |		КОГДА ХозрасчетныйОбороты.Субконто2 ССЫЛКА Справочник.ОсновныеСредства
//	               |			ТОГДА ХозрасчетныйОбороты.Субконто2
//	               |		КОГДА ХозрасчетныйОбороты.Субконто3 ССЫЛКА Справочник.ОсновныеСредства
//	               |			ТОГДА ХозрасчетныйОбороты.Субконто3
//	               |		ИНАЧЕ 0
//	               |	КОНЕЦ,
//	               |	ХозрасчетныйОбороты.Организация,
//	               |	ХозрасчетныйОбороты.Валюта,
//	               |	ХозрасчетныйОбороты.ВалютаКор,
//	               |	ХозрасчетныйОбороты.Подразделение,
//	               |	ХозрасчетныйОбороты.ПодразделениеКор,
//	               |	ХозрасчетныйОбороты.Регистратор,
//	               |	ХозрасчетныйОбороты.Регистратор.Дата,
//	               |	ХозрасчетныйОбороты.СуммаОборотДт
//	               |ИЗ
//	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&Счет01, &Счет03), , {(Организация)}, , ) КАК ХозрасчетныйОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//	               |		ПО ХозрасчетныйОбороты.Регистратор = бит_му_КомплектацияОС.ДокументРСБУ
//	               |			И ХозрасчетныйОбороты.Субконто1 = бит_му_КомплектацияОС.АналитикаРСБУ
//	               |ГДЕ
//	               |	бит_му_КомплектацияОС.ДокументРСБУ ЕСТЬ NULL 
//	               |	И ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков
//	               |	И ХозрасчетныйОбороты.Регистратор.РазделУчета = &РазделУчета
//	               |{ГДЕ
//	               |	(ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто1.Объект КАК Справочник.ОбъектыСтроительства)).* КАК ОбъектСтроительства,
//	               |	ХозрасчетныйОбороты.Регистратор.*}
//	               |;
//	               |
//	               |////////////////////////////////////////////////////////////////////////////////
//	               |ВЫБРАТЬ
//	               |	ВТХозрасчетныеОбороты.ОсновноеСредство КАК ВНА,
//	               |	ВТХозрасчетныеОбороты.Организация,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
//	               |	ВТХозрасчетныеОбороты.Регистратор КАК ДокументБУ,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость,
//	               |	ВТХозрасчетныеОбороты.Выполнять,
//	               |	СостоянияОСОрганизацийСрезПоследних.ДатаСостояния КАК ДатаПринятияКУчету,
//	               |	ВТХозрасчетныеОбороты.РегистраторДата КАК РегистраторДата,
//	               |	ТИПЗНАЧЕНИЯ(ВТХозрасчетныеОбороты.Регистратор) КАК ТипРегистратора,
//	               |	СУММА(ВТХозрасчетныеОбороты.Сумма) КАК Сумма,
//	               |	ВТХозрасчетныеОбороты.Счет
//	               |ИЗ
//	               |	ВТХозрасчетныеОбороты КАК ВТХозрасчетныеОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация)}) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
//	               |			И ВТХозрасчетныеОбороты.Организация = МестонахождениеОСБухгалтерскийУчетСрезПоследних.Организация
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, ) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций.СрезПоследних КАК СостоянияОСОрганизацийСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = СостоянияОСОрганизацийСрезПоследних.ОсновноеСредство
//	               |			И (СостоянияОСОрганизацийСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету))
//	               |{ГДЕ
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ.*,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение.*}
//	               |
//	               |СГРУППИРОВАТЬ ПО
//	               |	ВТХозрасчетныеОбороты.ОсновноеСредство,
//	               |	ВТХозрасчетныеОбороты.Организация,
//	               |	ВТХозрасчетныеОбороты.Регистратор,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер,
//	               |	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость,
//	               |	ВТХозрасчетныеОбороты.Выполнять,
//	               |	СостоянияОСОрганизацийСрезПоследних.ДатаСостояния,
//	               |	ВТХозрасчетныеОбороты.РегистраторДата,
//	               |	ВТХозрасчетныеОбороты.Счет
//	               |
//	               |УПОРЯДОЧИТЬ ПО
//	               |	РегистраторДата,
//	               |	ТипРегистратора,
//	               |	ВТХозрасчетныеОбороты.Регистратор.Номер";

//	Возврат ТекстЗапроса;
//		
//КонецФункции // СформироватьТекстЗапросаПринятиеКУчетуОС()

////БИТ Тртилек 08.08.2012 Функция формирует текст запроса для режима КомплектацияОС
//Функция СформироватьТекстЗапросаКомплектацияОС()

//	ТекстЗапроса = 
//			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
//			|	ИСТИНА КАК Выполнять,
//			|	ТабЧасть.ОсновноеСредство КАК ВНА,
//			|	ТабЧасть.Ссылка.Организация,
//			|	МестонахождениеОСБУ.Местонахождение,
//			|	МестонахождениеОСБУ.МОЛ,
//			|	ТабЧасть.Ссылка.Ссылка КАК ДокументБУ,
//			|	ПервоначальныеСведенияОСБУ.ИнвентарныйНомер,
//			|	ТабЧасть.Ссылка.ОбъектСтроительства
//			|ПОМЕСТИТЬ ВТДокументыПринятиеМодернизация
//			|ИЗ
//			|	Документ.МодернизацияОС.ОС КАК ТабЧасть
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация), (ОсновноеСредство)}) КАК ПервоначальныеСведенияОСБУ
//			|		ПО ТабЧасть.ОсновноеСредство = ПервоначальныеСведенияОСБУ.ОсновноеСредство
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация), (ОсновноеСредство)}) КАК МестонахождениеОСБУ
//			|		ПО ТабЧасть.ОсновноеСредство = МестонахождениеОСБУ.ОсновноеСредство
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_ПараметрыОС.СрезПоследних(&КонецПериода, Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_ОС) {(Организация), (ОсновноеСредство)}) КАК КлассыОС_МУ
//			|		ПО ТабЧасть.ОсновноеСредство = КлассыОС_МУ.ОсновноеСредство
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//			|		ПО ТабЧасть.ОсновноеСредство = бит_му_КомплектацияОС.АналитикаРСБУ
//			|			И ТабЧасть.Ссылка.Ссылка = бит_му_КомплектацияОС.ДокументРСБУ
//			|ГДЕ
//			|	ТабЧасть.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
//			|	И бит_му_КомплектацияОС.Регистратор ЕСТЬ NULL 
//			|{ГДЕ
//			|	ТабЧасть.ОсновноеСредство.* КАК ВНА,
//			|	ТабЧасть.Ссылка.Организация.*,
//			|	МестонахождениеОСБУ.Местонахождение.*,
//			|	МестонахождениеОСБУ.МОЛ.*,
//			|	ТабЧасть.Ссылка.Проведен,
//			|	ТабЧасть.Ссылка.ОбъектСтроительства.*}
//			|
//			|СГРУППИРОВАТЬ ПО
//			|	ТабЧасть.ОсновноеСредство,
//			|	МестонахождениеОСБУ.Местонахождение,
//			|	МестонахождениеОСБУ.МОЛ,
//			|	ТабЧасть.Ссылка.Ссылка,
//			|	ПервоначальныеСведенияОСБУ.ИнвентарныйНомер,
//			|	ТабЧасть.Ссылка.Организация,
//			|	ТабЧасть.Ссылка.ОбъектСтроительства
//			|
//			|ОБЪЕДИНИТЬ ВСЕ
//			|
//			|ВЫБРАТЬ
//			|	ИСТИНА,
//			|	ТабЧасть.ОсновноеСредство,
//			|	ТабЧасть.Ссылка.Организация,
//			|	МестонахождениеОСБУ.Местонахождение,
//			|	МестонахождениеОСБУ.МОЛ,
//			|	ТабЧасть.Ссылка.Ссылка,
//			|	ПервоначальныеСведенияОСБУ.ИнвентарныйНомер,
//			|	ТабЧасть.Ссылка.ОбъектСтроительства
//			|ИЗ
//			|	Документ.ПринятиеКУчетуОС.ОсновныеСредства КАК ТабЧасть
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация), (ОсновноеСредство)}) КАК ПервоначальныеСведенияОСБУ
//			|		ПО ТабЧасть.ОсновноеСредство = ПервоначальныеСведенияОСБУ.ОсновноеСредство
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация), (ОсновноеСредство)}) КАК МестонахождениеОСБУ
//			|		ПО ТабЧасть.ОсновноеСредство = МестонахождениеОСБУ.ОсновноеСредство
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_ПараметрыОС.СрезПоследних(&КонецПериода, Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_ОС) {(Организация), (ОсновноеСредство)}) КАК КлассыОС_МУ
//			|		ПО ТабЧасть.ОсновноеСредство = КлассыОС_МУ.ОсновноеСредство
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//			|		ПО ТабЧасть.Ссылка.Ссылка = бит_му_КомплектацияОС.ДокументРСБУ
//			|			И ТабЧасть.ОсновноеСредство = бит_му_КомплектацияОС.АналитикаРСБУ
//			|ГДЕ
//			|	ТабЧасть.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
//			|	И бит_му_КомплектацияОС.Регистратор ЕСТЬ NULL 
//			|{ГДЕ
//			|	ТабЧасть.ОсновноеСредство.* КАК ВНА,
//			|	ТабЧасть.Ссылка.Организация.*,
//			|	МестонахождениеОСБУ.Местонахождение.*,
//			|	МестонахождениеОСБУ.МОЛ.*,
//			|	ТабЧасть.Ссылка.Проведен,
//			|	ТабЧасть.Объект.* КАК ОбъектСтроительства}
//			|
//			|СГРУППИРОВАТЬ ПО
//			|	ТабЧасть.ОсновноеСредство,
//			|	МестонахождениеОСБУ.Местонахождение,
//			|	МестонахождениеОСБУ.МОЛ,
//			|	ТабЧасть.Ссылка.Ссылка,
//			|	ПервоначальныеСведенияОСБУ.ИнвентарныйНомер,
//			|	ТабЧасть.Ссылка.Организация,
//			|	ТабЧасть.Ссылка.ОбъектСтроительства
//			|;
//			|
//			|////////////////////////////////////////////////////////////////////////////////
//			|ВЫБРАТЬ
//			|	ВТДокументыПринятиеМодернизация.Выполнять,
//			|	ВТДокументыПринятиеМодернизация.Организация,
//			|	ВТДокументыПринятиеМодернизация.ДокументБУ,
//			|	ВТДокументыПринятиеМодернизация.ОбъектСтроительства,
//			|	ХозрасчетныйОбороты.СуммаОборотДт КАК Сумма
//			|ИЗ
//			|	ВТДокументыПринятиеМодернизация КАК ВТДокументыПринятиеМодернизация
//			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, , , {(Организация)}, , ) КАК ХозрасчетныйОбороты
//			|		ПО ВТДокументыПринятиеМодернизация.ДокументБУ = ХозрасчетныйОбороты.Регистратор";
//		
//	        Возврат ТекстЗапроса;

//	
//		КонецФункции
//		
//// BIT Avseenkov 15052014 /Доработка функцонала по уастку основных средств {
//Функция СформироватьТекстЗапросаОС07_0804()

//	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	               |	ИСТИНА КАК Выполнять,
//	               |	ХозрасчетныйОбороты.Счет,
//	               |	ХозрасчетныйОбороты.Субконто1,
//	               |	ХозрасчетныйОбороты.Субконто2,
//	               |	ХозрасчетныйОбороты.Субконто3,
//	               |	ХозрасчетныйОбороты.КорСчет,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОСвОрганизации), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МЦвОрганизации))
//	               |			ТОГДА ВЫБОР
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто1 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто1
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто2 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто2
//	               |					КОГДА ХозрасчетныйОбороты.КорСубконто3 ССЫЛКА Справочник.ОсновныеСредства
//	               |						ТОГДА ХозрасчетныйОбороты.КорСубконто3
//	               |					ИНАЧЕ 0
//	               |				КОНЕЦ
//	               |	КОНЕЦ КАК ОсновноеСредство,
//	               |	ХозрасчетныйОбороты.Организация,
//	               |	ХозрасчетныйОбороты.Валюта,
//	               |	ХозрасчетныйОбороты.ВалютаКор,
//	               |	ХозрасчетныйОбороты.Подразделение,
//	               |	ХозрасчетныйОбороты.ПодразделениеКор,
//	               |	ХозрасчетныйОбороты.Регистратор,
//	               |	ХозрасчетныйОбороты.Регистратор.Дата,
//	               |	ВЫБОР
//	               |		КОГДА ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОСвОрганизации), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МЦвОрганизации))
//	               |			ТОГДА -ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотДт, 0) + ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, 0)
//	               |		ИНАЧЕ ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотДт, 0) - ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, 0)
//	               |	КОНЕЦ КАК Сумма
//	               |ПОМЕСТИТЬ ВТХозрасчетныеОбороты
//	               |ИЗ
//	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&Счет07, &Счет0804), , {(Организация)}, , ) КАК ХозрасчетныйОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
//	               |		ПО ХозрасчетныйОбороты.Регистратор = бит_му_КомплектацияОС.ДокументРСБУ
//	               |ГДЕ
//	               |	бит_му_КомплектацияОС.ДокументРСБУ ЕСТЬ NULL 
//	               |{ГДЕ
//	               |	(ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто2 КАК Справочник.Склады)).* КАК Склад,
//	               |	ХозрасчетныйОбороты.Регистратор.*}
//	               |;
//	               |
//	               |////////////////////////////////////////////////////////////////////////////////
//	               |ВЫБРАТЬ
//	               |	ВТХозрасчетныеОбороты.Организация,
//	               |	ВТХозрасчетныеОбороты.Регистратор КАК ДокументБУ,
//	               |	ВТХозрасчетныеОбороты.Выполнять,
//	               |	ВТХозрасчетныеОбороты.РегистраторДата КАК РегистраторДата,
//	               |	ТИПЗНАЧЕНИЯ(ВТХозрасчетныеОбороты.Регистратор) КАК ТипРегистратора,
//	               |	СУММА(ВТХозрасчетныеОбороты.Сумма) КАК Сумма,
//	               |	ВТХозрасчетныеОбороты.Счет
//	               |ИЗ
//	               |	ВТХозрасчетныеОбороты КАК ВТХозрасчетныеОбороты
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, {(Организация)}) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
//	               |			И ВТХозрасчетныеОбороты.Организация = МестонахождениеОСБухгалтерскийУчетСрезПоследних.Организация
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&КонецПериода, ) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций.СрезПоследних КАК СостоянияОСОрганизацийСрезПоследних
//	               |		ПО ВТХозрасчетныеОбороты.ОсновноеСредство = СостоянияОСОрганизацийСрезПоследних.ОсновноеСредство
//	               |			И (СостоянияОСОрганизацийСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету))
//	               |{ГДЕ
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ.*,
//	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение.*}
//	               |
//	               |СГРУППИРОВАТЬ ПО
//	               |	ВТХозрасчетныеОбороты.Организация,
//	               |	ВТХозрасчетныеОбороты.Регистратор,
//	               |	ВТХозрасчетныеОбороты.Выполнять,
//	               |	ВТХозрасчетныеОбороты.РегистраторДата,
//	               |	ВТХозрасчетныеОбороты.Счет
//	               |
//	               |УПОРЯДОЧИТЬ ПО
//	               |	РегистраторДата,
//	               |	ТипРегистратора,
//	               |	ВТХозрасчетныеОбороты.Регистратор.Номер";

//	Возврат ТекстЗапроса;
//		
//КонецФункции

