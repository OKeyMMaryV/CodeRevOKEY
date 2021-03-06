//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-11-05 (#ПроектИнтеграцияАксапта12)
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()

	//Количество субконто
	Организация_Окей = бит_БК_Общий.ПолучитьЗначениеНастройкиМеханизмаИмпортаДанных("Организации", "Организация ОКЕЙ");
	Если Объект.Организация <> Организация_Окей Тогда
		КоличествоСубконтоАксапта = 6;
	Иначе
		КоличествоСубконтоАксапта = ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Аксапта 12", "Количество субконто Аксапта", 6);
	КонецЕсли; 
	
	Для Инд = 1 По 12 Цикл
		Элементы["ТипСубконто" + Инд].ТолькоПросмотр = КоличествоСубконтоАксапта < Инд;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-11-05 (#ПроектИнтеграцияАксапта12)