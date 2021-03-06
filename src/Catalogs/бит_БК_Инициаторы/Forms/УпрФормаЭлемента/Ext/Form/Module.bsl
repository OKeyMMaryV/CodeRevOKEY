// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-28 (#4391)

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ок_УправлениеФормами.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеФормой();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ок_УволенПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеФормой()
	Элементы.ок_ДатаУвольнения.Видимость = Объект.ок_Уволен;
КонецПроцедуры

#КонецОбласти

// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-28 (#4391)


//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-05-18 (#3750)
//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	_Объект = РеквизитФормыВЗначение("Объект");
//	ВыриантыФорм = _Объект.ВариантыФорм();
//	Для Каждого ВариантФормы ИЗ ВыриантыФорм Цикл 
//		ЗаполнитьЗначенияСвойств(Элементы.ИспользуемаяФорма.СписокВыбора.Добавить(), ВариантФормы);
//	КонецЦикла;
//КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-05-18 (#3750)